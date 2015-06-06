#!/bin/bash
#
# Script to build .cwe files for download via 'FDT'
#
# !!NOTE!!:  On some virtualized hosts (e.g. Virtual Box) the
#            hdrcnv utility will not run if it is on a shared
#            windows folder.  I.e. it must be on the Linux
#            drive.
#            The problem is that the dynamic linker will throw
#            an error
#
#set -x
#ln -s /bin/rm del
#PATH=.:$PATH

# Usage message
#
USAGE="`basename $0` [-o <filename>] [-z] [-fbt <Fast Boot>] [-rfs <root fs>] [-kernel <Linux Kernel>] [-ufs <GOS2 elf>] [-pid <package ID>]\n\n

All arguments are optional: \n
-o    <filename> output file(default output file yocto.cwe or yoctoz.cwe)\n
-z  to gernerate cwe with zip format \n
-fbt  fast boot image, default file appsboot.mbn\n
-rfs  rootfs binary, default file rootfs\n
-kernel  kernel image, default file kernel\n
-ufs  Legato file system image\n
-pid  CWE package ID(default is 'A911' for AR755x 2G/4G memory products; use '9X15' for WP710x products) \n
at least fast boot image, root fs, kernel image are needed to generate yocto cwe file"

TOOLDIR=`dirname $0`
OUTFILE=`pwd`/yocto.cwe
OUTZFILE=`pwd`/yoctoz.cwe
RFS_FILE="rootfs"
UFS_FILE=""
FBT_FILE=""
KERNEL_FILE="kernel"

# create a symlink hdrcnv to the real hdrcnv utility
HDRCNV=""
ARCH=$(uname -m)
HDRCNV=hdrcnv
CWEZIP=cwezip

y=${1%.*}
DATESTAMP=$(date)
COMPAT_BYTE=00000001
PLATFORM=9X15
PKID=A911

APPL_SIG=0000

ZIP_EN="no"

# Parse parameter list
#
until [ -z "$1" ]  # Until all parameters used up...
  do
  case $1 in
      "-o" | "-O")              # output file name
          shift
          OUTFILE=$1
          OUTZFILE=$1
          ;;

      "-z" | "-Z")              # enable ZIP
          ZIP_EN="yes"
          ;;

      "-rfs" | "-RFS")        # root fs file
          shift
          RFS_FILE=$1
          ;;

      "-ufs" | "-UFS")        # user fs file
          shift
          UFS_FILE=$1
          ;;

      "-fbt" | "-FBT")        # boot image
          shift
          FBT_FILE=$1
          ;;

      "-kernel" | "-KERNEL")        # kernel image
          shift
          KERNEL_FILE=$1
          ;;
      "-pid" | "-PID")        # kernel image
          shift
          PKID=$1
          ;;
      "-h" | "--h")        # kernel image
          echo -e $USAGE
          exit 1
          ;;
      *)
          echo -e "unrecognized argument: $1\n"
          echo -e $USAGE
          exit 1
  esac
  shift
done

TMPMBN=`dirname ${OUTFILE}`/temp.mbn

if [ "${ZIP_EN}" = "yes" ] ; then
      OUTFILE=$OUTZFILE
fi

if [ -f ${TMPMBN} ] ; then
    rm -f ${TMPMBN}.data
fi

function check_exist() {
  IMG_FILE=$1

  if ! [ -e "$IMG_FILE" ] ; then
    echo "ERROR: $IMG_FILE doesn't exist"
    exit 1
  fi
}

if [ -n "${RFS_FILE}" ] ; then
    echo -e "\nGenerating CWE for rootfs ${RFS_FILE}"
    check_exist ${RFS_FILE}
    if [ -f ${TMPMBN} ] ; then rm -f ${TMPMBN}; fi
    if [ -f ${TMPMBN}.hdr ] ; then rm -f ${TMPMBN}.hdr; fi
    if [ -f ${TMPMBN}.cwe ] ; then rm -f ${TMPMBN}.cwe; fi
    cp ${RFS_FILE} ${TMPMBN}
    $HDRCNV ${TMPMBN} -OH ${TMPMBN}.hdr -IT SYST -PT $PLATFORM -V "${DATESTAMP}" -B $COMPAT_BYTE
    cat ${TMPMBN}.hdr ${TMPMBN} > ${TMPMBN}.cwe
    if [ "${ZIP_EN}" = "yes" ] ; then
        if [ -f ${TMPMBN}.cwe.z ] ; then rm -f ${TMPMBN}.cwe.z; fi
        $CWEZIP  ${TMPMBN}.cwe -c -o  ${TMPMBN}.cwe.z
        dd if=${TMPMBN}.cwe.z >> ${TMPMBN}.data
    else
        dd if=${TMPMBN}.cwe >> ${TMPMBN}.data
    fi
fi

if [ -n "${UFS_FILE}" ] ; then
    echo -e "\nGenerating CWE for userfs ${UFS_FILE}"
    check_exist ${UFS_FILE}
    if [ -f ${TMPMBN} ] ; then rm -f ${TMPMBN}; fi
    if [ -f ${TMPMBN}.hdr ] ; then rm -f ${TMPMBN}.hdr; fi
    if [ -f ${TMPMBN}.cwe ] ; then rm -f ${TMPMBN}.cwe; fi
    cp ${UFS_FILE} ${TMPMBN}
    $HDRCNV ${TMPMBN} -OH ${TMPMBN}.hdr -IT USER -PT $PLATFORM -V "${DATESTAMP}" -B $COMPAT_BYTE
    cat ${TMPMBN}.hdr ${TMPMBN} > ${TMPMBN}.cwe
    if [ "${ZIP_EN}" = "yes" ] ; then
        if [ -f ${TMPMBN}.cwe.z ] ; then rm -f ${TMPMBN}.cwe.z; fi
        $CWEZIP  ${TMPMBN}.cwe -c -o  ${TMPMBN}.cwe.z
        dd if=${TMPMBN}.cwe.z >> ${TMPMBN}.data
    else
        dd if=${TMPMBN}.cwe >> ${TMPMBN}.data
    fi
fi

if [ -n "${FBT_FILE}" ] ; then
    echo -e "\nGenerating CWE for bootloader ${FBT_FILE}"
    check_exist ${FBT_FILE}
    if [ -f ${TMPMBN} ] ; then rm -f ${TMPMBN}; fi
    if [ -f ${TMPMBN}.hdr ] ; then rm -f ${TMPMBN}.hdr; fi
    if [ -f ${TMPMBN}.cwe ] ; then rm -f ${TMPMBN}.cwe; fi
    cp ${FBT_FILE} ${TMPMBN}
    $HDRCNV ${TMPMBN} -OH ${TMPMBN}.hdr -IT APBL -PT $PLATFORM -V "${DATESTAMP}" -B $COMPAT_BYTE
    cat ${TMPMBN}.hdr ${TMPMBN} > ${TMPMBN}.cwe
    dd if=${TMPMBN}.cwe >> ${TMPMBN}.data
fi

if [ -n "${KERNEL_FILE}" ] ; then
    echo -e "\nGenerating CWE for kernel ${KERNEL_FILE}"
    check_exist ${KERNEL_FILE}
    if [ -f ${TMPMBN} ] ; then rm -f ${TMPMBN}; fi
    if [ -f ${TMPMBN}.hdr ] ; then rm -f ${TMPMBN}.hdr; fi
    if [ -f ${TMPMBN}.cwe ] ; then rm -f ${TMPMBN}.cwe; fi
    cp ${KERNEL_FILE} ${TMPMBN}
    $HDRCNV ${TMPMBN} -OH ${TMPMBN}.hdr -IT APPS -PT $PLATFORM -V "${DATESTAMP}" -B $COMPAT_BYTE
    cat ${TMPMBN}.hdr ${TMPMBN} > ${TMPMBN}.cwe
    if [ "${ZIP_EN}" = "yes" ] ; then
        if [ -f ${TMPMBN}.cwe.z ] ; then rm -f ${TMPMBN}.cwe.z; fi
        $CWEZIP  ${TMPMBN}.cwe -c -o  ${TMPMBN}.cwe.z
        dd if=${TMPMBN}.cwe.z >> ${TMPMBN}.data
    else
        dd if=${TMPMBN}.cwe >> ${TMPMBN}.data
    fi
fi

echo "Creating Top-level CWE header.  Type = APPL"
$HDRCNV ${TMPMBN}.data -OH $TMPMBN.hdr -IT APPL -PT $PKID -V "${DATESTAMP}" -B $COMPAT_BYTE

echo "Concatenating files to create: ${OUTFILE}"
dd if=${TMPMBN}.hdr > ${OUTFILE}
dd if=${TMPMBN}.data >> ${OUTFILE}
#
rm -f ${TMPMBN}.hdr ${TMPMBN}.data ${TMPMBN} ${TMPMBN}.hdr ${TMPMBN}.cwe ${TMPMBN}.cwe.z

exit

