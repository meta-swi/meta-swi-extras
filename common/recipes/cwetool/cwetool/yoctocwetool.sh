#!/bin/sh
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
FBT_FILE="appsboot.mbn"
KERNEL_FILE="kernel"

# create a symlink hdrcnv to the real hdrcnv utility
HDRCNV=""
ARCH="`uname -m`"
#[ "$ARCH" = "x86_64" ] && HDRCNV=$TOOLDIR/hdrcnv-Lin64.exe  # need to use SL3 CWE tool
#[ "$ARCH" = "i686"   ] && HDRCNV=$TOOLDIR/hdrcnv-Lin32.exe  # need to use SL3 CWE tool
#[ -z "$HDRCNV" ] && HDRCNV=$TOOLDIR/hdrcnv
HDRCNV=hdrcnv
#[ -f "$HDRCNV" ] || exit 1
CWEZIP=cwezip
#[ -f "$CWEZIP" ] || exit 1

y=${1%.*}
DATESTAMP=`date`
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

if [ ${RFS_FILE} ] && [ -f ${RFS_FILE} ] ; then
    echo "\ngenerating CWE for ${RFS_FILE}"
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
elif [ ${RFS_FILE} ] ; then
    echo -e "rootfs file: $RFS_FILE not found "
    exit 1
fi

if [ ${UFS_FILE} ] && [ -f ${UFS_FILE} ] ; then
    echo "\ngenerating CWE for ${UFS_FILE}"
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

if [ ${FBT_FILE} ] && [ -f ${FBT_FILE} ] ; then
    echo "\ngenerating CWE for ${FBT_FILE}"
    if [ -f ${TMPMBN} ] ; then rm -f ${TMPMBN}; fi
    if [ -f ${TMPMBN}.hdr ] ; then rm -f ${TMPMBN}.hdr; fi
    if [ -f ${TMPMBN}.cwe ] ; then rm -f ${TMPMBN}.cwe; fi
    cp ${FBT_FILE} ${TMPMBN}
    $HDRCNV ${TMPMBN} -OH ${TMPMBN}.hdr -IT APBL -PT $PLATFORM -V "${DATESTAMP}" -B $COMPAT_BYTE
    cat ${TMPMBN}.hdr ${TMPMBN} > ${TMPMBN}.cwe
    dd if=${TMPMBN}.cwe >> ${TMPMBN}.data
elif [ ${FBT_FILE} ] ; then
    echo -e "boot image: $FBT_FILE not found "
    exit 1
fi

if [ ${KERNEL_FILE} ] && [ -f ${KERNEL_FILE} ] ; then
    echo "\ngenerating CWE for ${KERNEL_FILE}"
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
elif [ ${KERNEL_FILE} ] ; then
    echo -e "kernel image: $KERNEL_FILE not found "
    exit 1
fi

echo "Creating Top-level CWE header.  Type = APPL"
$HDRCNV ${TMPMBN}.data -OH $TMPMBN.hdr -IT APPL -PT $PKID -V "${DATESTAMP}" -B $COMPAT_BYTE

echo "Concatenating files to create: ${OUTFILE}"
dd if=${TMPMBN}.hdr > ${OUTFILE}
dd if=${TMPMBN}.data >> ${OUTFILE}
#
rm -f ${TMPMBN}.hdr ${TMPMBN}.data ${TMPMBN} ${TMPMBN}.hdr ${TMPMBN}.cwe ${TMPMBN}.cwe.z

exit

