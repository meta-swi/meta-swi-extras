#!/bin/bash
#
# Copyright (c) 2011-2012 Wind River Systems, Inc.
#

# Let bitbake use the following env-vars as if they were pre-set bitbake ones.
# (BBLAYERS is explicitly blocked from this within OE-Core itself, though...)
export BB_ENV_EXTRAWHITE="http_proxy MACHINE DISTRO DL_DIR"

IFS='
    '

PATH=/usr/local/bin:/bin:/usr/bin
export PATH


UMASK=022
umask $UMASK

scriptdir=$(cd $(dirname ${0}); pwd)
WS="$scriptdir/../poky"

DEF_LEGATO="false"

ALL_ARGS="$*"

usage()
{
    cat << EOF
Usage:
$0 <options ...>

  Global:
    -p <poky_dir>
    -o <meta-openembedded dir>
    -l <SWI meta layer>
    -x <linux repo directory>
    -m <SWI machine type>
    -b <build_dir>
    -t <number of bitbake tasks>
    -j <number of make threads>
    -r (enable preempt-rt kernel <Test-only. Not supported>)
    -g (enable Legato setup and build Legato images)
    -a (pass extra options for recipes, key=value separated by ::)

  Machine swi-mdm9x15:
    -q (enable Qualcomm Proprietary bin)
    -s (enable Qualcomm Proprietary source)
    -w <Qualcomm source directory (apps_proc)>
    -v <version of Qualcomm sources>

  Task control:
    -c (enable command line mode)
    -d (build the full debug image)
    -k (build the toolchain)
EOF
}

usage_and_exit()
{
    usage
    exit $1
}

if [ $# = 0 ]; then
    usage_and_exit 1
fi

BD="$scriptdir/../build" MACH=swi-mdm9x15 DEBUG=false TASKS=4 THREADS=4 CMD_LINE=false TOOLCHAIN=false ENABLE_RT=false ENABLE_PROPRIETARY=false ENABLE_PROPRIETARY_SRC=false ENABLE_ICECC=false DISTRO=poky-swi

while getopts ":p:o:b:l:x:m:t:j:w:v:a:cdrqsgkh" arg
do
    case $arg in
    p)
        WS=$(readlink -f $OPTARG)
        echo "Poky dir: $WS"
        ;;
    o)
        OE=$(readlink -f $OPTARG)
        echo "OE meta: $OE"
        ;;
    b)
        BD=$(readlink -f $OPTARG)
        echo "Build dir: $BD"
        ;;
    l)
        SWI=$(readlink -f $OPTARG)
        echo "SWI meta dir: $SWI"
        ;;
    x)
        LINUXDIR=$(readlink -f $OPTARG)
        echo "Linux repo dir: $LINUXDIR"
        ;;
    m)
        MACH=$OPTARG
        echo "SWI machine: $MACH"
        ;;
    d)
        DEBUG=true
        echo "Enable more packages for debugging"
        ;;
    t)
        TASKS=$OPTARG
        echo "Number of bitbake tasks $TASKS"
        ;;
    j)
        THREADS=$OPTARG
        echo "Number of make threads $THREADS"
        ;;
    a)
        X_OPTS=$OPTARG
        echo "Extra options added -  $X_OPTS"
        ;;
    c)  CMD_LINE=true
        echo "Enable command line mode"
        ;;
    r)  ENABLE_RT=true
        echo "Enable preempt-rt kernel. ** WARNING - unsupported kernel mode **"
        ;;
    q)  ENABLE_PROPRIETARY=true
        echo "Enable Qualcomm Proprietary bin"
        ;;
    s)  ENABLE_PROPRIETARY_SRC=true
        echo "Enable Qualcomm Proprietary source - overrides binary option"
        ;;
    w)
        WK=$(readlink -f $OPTARG)
        ;;
    v)
        FW_VERSION=$OPTARG
        ;;
    g)
        DEF_LEGATO="true"
        ;;
    k)  TOOLCHAIN=true
        echo "Build toolchain"
        ;;
    h)  ENABLE_ICECC=true
        echo "Build using icecc"
        ;;
    ?)
        echo "$0: invalid option -$OPTARG" 1>&2
        usage_and_exit 1
        ;;
    esac
done

. ${WS}/oe-init-build-env $BD

## Conf: bblayers.conf

enable_layer()
{
    LAYER_NAME=$1
    LAYER_PATH=$2
    PREVIOUS_LAYER=$3

    if [ -z "$PREVIOUS_LAYER" ]; then
        PREVIOUS_LAYER='meta-yocto-bsp'
    fi

    echo "+ layer: $LAYER_NAME"

    grep -E "/$LAYER_NAME " $BD/conf/bblayers.conf > /dev/null
    if [ $? != 0 ]; then
        sed -e '/'"$PREVIOUS_LAYER"'/a\  '"$LAYER_PATH"' \\' -i $BD/conf/bblayers.conf
    fi
}

if test $MACH = "swi-s6"; then
    # Enable the meta-swi-s6 layer
    enable_layer "meta-swi-s6" "$SWI/meta-swi-s6"
elif test $MACH = "swi-virt-arm" || test $MACH = "swi-virt-x86"; then
    # Enable the meta-swi-virt layer
    enable_layer "meta-swi-virt" "$SWI/meta-swi-virt"
else
    # Enable the meta-swi-mdm9x15 layer
    enable_layer "meta-swi-mdm9x15" "$SWI/meta-swi-mdm9x15"

    # Distro to poky-swi-ext to change SDKPATH
    DISTRO="poky-swi-ext"
fi

# Enable the meta-swi layer
enable_layer "meta-swi" $SWI

# Enable the meta-oe layer
enable_layer "meta-oe" "$OE/meta-oe"

# Enable the meta-networking layer
enable_layer "meta-networking" "$OE/meta-networking"

# Enable proprietary layers: from sources
if [ $ENABLE_PROPRIETARY_SRC = true ]; then
    # Check that we have a source workspace to point to
    WK=${WK:-$WORKSPACE}
    WORKSPACE=${WK:?"Not set - must point to apps_proc of firmware build"}

    if [ ! -d ${WORKSPACE}/qmi ]
    then
        echo WORKSPACE \(${WORKSPACE}\) appears not to be a valid source location
        echo WORKSPACE must point to apps_proc of firmware build
        exit 1
    fi

    echo "Workspace dir: $WORKSPACE"
    export WORKSPACE

    if [ -n "$FW_VERSION" ]; then
        echo "Workspace version: $FW_VERSION"
        export FW_VERSION
    fi

    enable_layer "meta-swi-src" "$scriptdir/meta-swi-src" "meta-swi-mdm9x15"

    ENABLE_PROPRIETARY=false

    # We have to copy the dx files from the modem dir
    cp -f $WORKSPACE/../modem_proc/sierra/src/dx/src/common/* $WORKSPACE/sierra/dx/common
    if [ $? != 0 ]; then
        echo "Unable to copy dx common files from modem_proc"
        exit 1
    fi
    cp -f $WORKSPACE/../modem_proc/sierra/src/dx/api/common/* $WORKSPACE/sierra/dx/common
    if [ $? != 0 ]; then
        echo "Unable to copy dx common API files from modem_proc"
        exit 1
    fi
    # We have to copy the qapi files from the modem dir
    cp -f $WORKSPACE/../modem_proc/sierra/src/qapi/src/common/* $WORKSPACE/sierra/qapi/common
    if [ $? != 0 ]; then
        echo "Unable to copy qapi common files from modem_proc"
        exit 1
    fi
    # Provice common qcsi files as a link to common qapi files
    rm -rf $WORKSPACE/sierra/qcsi/common && ( cd $WORKSPACE/sierra/qcsi && ln -s ../qapi/common common )
    if [ $? != 0 ]; then
        echo "Unable to provide qcsi common files from modem_proc"
        exit 1
    fi
    # We have to copy the NV files from the modem dir
    cp -f $WORKSPACE/../modem_proc/sierra/src/nv/src/common/* $WORKSPACE/sierra/nv/common
    if [ $? != 0 ]; then
        echo "Unable to copy NV common files from modem_proc"
        exit 1
    fi
    cp -f $WORKSPACE/../modem_proc/sierra/src/nv/api/common/* $WORKSPACE/sierra/nv/common
    if [ $? != 0 ]; then
        echo "Unable to copy NV API files from modem_proc"
        exit 1
    fi
fi

# Enable proprietary layers: from binaries
if [ $ENABLE_PROPRIETARY = true ]; then
    enable_layer "meta-swi-bin" "$scriptdir/meta-swi-bin" "meta-swi-mdm9x15"
fi

# Enable proprietary layers: common
if [ $ENABLE_PROPRIETARY_SRC = true ] || [ $ENABLE_PROPRIETARY = true ]; then
    enable_layer "meta-swi-extras" "$scriptdir" "meta-swi-mdm9x15"
fi

## Conf: local.conf

# Tune local.conf file
sed -e 's:^\(MACHINE\).*:\1 = \"'$MACH'\":' -i $BD/conf/local.conf
grep -E "SOURCE_MIRROR_URL" $BD/conf/local.conf > /dev/null
if [ $? != 0 ]; then
        sed -e '/^#DL_DIR/a\SOURCE_MIRROR_URL ?= \"file\:\/\/'"$scriptdir"'/downloads\"\nINHERIT += \"own-mirrors\"\nBB_GENERATE_MIRROR_TARBALLS = \"1\"\nBB_NO_NETWORK = \"0\"\nWORKSPACE = \"'"${WORKSPACE}"'\"\nLINUX_REPO_DIR = \"'"${LINUXDIR}"'\"\nLEGATO_BUILD = \"'"${DEF_LEGATO}"'\"\nDISTRO = \"'"${DISTRO}"'\"' -i $BD/conf/local.conf
fi
sed -e 's:^#\(BB_NUMBER_THREADS\).*:\1 = \"'"$TASKS"'\":' -i $BD/conf/local.conf
sed -e 's:^#\(PARALLEL_MAKE\).*:\1 = \"-j '"$THREADS"'\":' -i $BD/conf/local.conf

if [ -n "$FW_VERSION" ]; then
    FW_VERSION_ENTRY=$(grep "FW_VERSION =" $BD/conf/local.conf)
    if [ $? != 0 ]; then
        # Append
        sed -e '/^WORKSPACE/a\FW_VERSION = \"'"${FW_VERSION}"'\"\n' -i $BD/conf/local.conf
    else
        CURRENT_FW_VERSION=$(echo $FW_VERSION_ENTRY | sed -e 's/FW_VERSION = \"\(.*\)\"/\1/g')
        if [[ "$FW_VERSION" != "$CURRENT_FW_VERSION" ]]; then
            # Update entry
            echo "Updating FW_VERSION from '${CURRENT_FW_VERSION}' to '${FW_VERSION}'"
            sed -e 's/FW_VERSION = \".*\"/FW_VERSION = \"'"${FW_VERSION}"'\"/g' -i $BD/conf/local.conf
        else
            echo "Keeping FW_VERSION '${FW_VERSION}'"
        fi
    fi
fi

# Add or update extra options
if [ -n "$X_OPTS" ]
then
    EXTRA_OPTS=$(echo $X_OPTS | sed -e "s/\:\:/ /g")
    for OPT in $EXTRA_OPTS
    do
        opt_name=$(echo $OPT | cut -d"=" -f1)
        opt_val=$(echo $OPT | cut -d"=" -f2-)

        OPT_ENTRY=$(grep "$opt_name =" $BD/conf/local.conf)
        if [ $? != 0 ]; then
            # Append
            echo "Adding option $opt_name with value $opt_val"
            echo "$opt_name = \"$opt_val\"" >> $BD/conf/local.conf
        else
            # Update entry
            echo "Updating $opt_name to $opt_val"
            sed -e "s/$opt_name = \".*//g" -i $BD/conf/local.conf
            echo "$opt_name = \"$opt_val\"" >> $BD/conf/local.conf
        fi
    done
fi


if [ $ENABLE_RT = true ]; then
    grep -E "PREFERRED_PROVIDER_virtual\/kernel" $BD/conf/local.conf > /dev/null
    if [ $? != 0 ]; then
        echo 'PREFERRED_PROVIDER_virtual/kernel = "linux-yocto-rt"' >> $BD/conf/local.conf
    else
        sed -e 's:^\(PREFERRED_PROVIDER_virtual\/kernel\).*:\1 = \"linux-yocto-rt\":' -i $BD/conf/local.conf
    fi
else
    grep -E "PREFERRED_PROVIDER_virtual\/kernel" $BD/conf/local.conf > /dev/null
    if [ $? != 0 ]; then
        echo 'PREFERRED_PROVIDER_virtual/kernel = "linux-yocto"' >> $BD/conf/local.conf
    else
        sed -e 's:^\(PREFERRED_PROVIDER_virtual\/kernel\).*:\1 = \"linux-yocto\":' -i $BD/conf/local.conf
    fi
fi

if [ $ENABLE_ICECC = true ]; then
    if ! grep icecc $BD/conf/local.conf > /dev/null; then
        echo 'INHERIT += "icecc"' >> $BD/conf/local.conf
        echo 'ICECC_PARALLEL_MAKE = "-j 20"' >> $BD/conf/local.conf
        echo 'ICECC_USER_PACKAGE_BL = "ncurses e2fsprogs libx11 gmp libcap perl busybox lk libgpg-error libarchive"' >> $BD/conf/local.conf
    fi
fi

cd $BD

# Command line
if [ $CMD_LINE = true ]; then
    /bin/bash
    exit 0
fi

# Toolchain
if [ $TOOLCHAIN = true ]; then
    if test $MACH = "swi-mdm9x15"; then
        bitbake meta-toolchain-swi-ext
    else
        bitbake meta-toolchain-swi
    fi
    exit $?
fi

# Images
echo -n "Build image of "
if [ $DEBUG = true ]; then
    echo "dev rootfs (for $MACH)."
    sed -e 's:^\(PACKAGE_CLASSES\).*:\1 = \"package_rpm\":' -i $BD/conf/local.conf
    if test $MACH = "swi-s6"; then
        bitbake swi-s6-image-dev
    elif test $MACH = "swi-virt-arm" || test $MACH = "swi-virt-x86"; then
        bitbake swi-virt-image-dev
    else
        bitbake mdm9x15-image-dev
    fi
else
    echo "minimal rootfs (for $MACH)."
    sed -e 's:^\(PACKAGE_CLASSES\).*:\1 = \"package_ipk\":' -i $BD/conf/local.conf
    if test $MACH = "swi-s6"; then
        bitbake swi-s6-image-minimal
    elif test $MACH = "swi-virt-arm" || test $MACH = "swi-virt-x86"; then
        echo "No minimal image for $MACH."
        exit 1
    else
        bitbake mdm9x15-image-minimal
    fi
fi

