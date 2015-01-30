#!/bin/bash
# 

usage()
{
    cat << EOF
Usage:
$0
    -b <build_dir>
    -o <output_dir>
    -v <version (FW version)>
EOF
}

usage_and_exit()
{
    usage
    exit $1
}

setup_dirs ()
{
    # Make sure the build dir looks valid
    if [ ! -d ${BD}/tmp/work/armv7a-vfp-neon-poky-linux-gnueabi ]
    then
        echo "Build dir appears not to be valid"
        echo "${BD}/tmp/work/armv7a-vfp-neon-poky-linux-gnueabi"
        usage_and_exit 1
    fi

    # Copy the old meta-swi-bin to the output directory
    if [ -d ${scriptdir}/${OD} ]
    then
        echo "Output dir (${scriptdir}/${OD}) already exists"
        usage_and_exit 1
    fi
    cd ${scriptdir}
    cp -R meta-swi-bin ${OD}
    echo "Created base output dir ${OD}"
}

package_basic ()
{
    package=$1
    version=$2
    remove_headers=$3
    
    if [ $# -eq 4 ] 
    then
        target=$4
    else
        target=${package}
    fi

    echo "Processing $package for directory ${target}"
    # First create a copy in /tmp to allow us to work
    rm -fr /tmp/${package}-bin
    mkdir /tmp/${package}-bin
    cp -R ${BD}/tmp/work/armv7a-vfp-neon-poky-linux-gnueabi/${package}/${version}/image/* /tmp/${package}-bin

    # Copy the license file into place
    if [ ${package} != "sierra" ]
    then
        cp ${OD}/recipes/LICENSE /tmp/${package}-bin
    fi

    if [ ${remove_headers} = "true" ]
    then
        # Now remove any header files
        cd /tmp/${package}-bin
        find . -name \*.h -exec rm {} \;
    else
        echo "Leaving $package headers in place"
    fi

    if [ ${package} = "qmi" ]
    then
        # Extra step for qmuxd
        cd /tmp/${package}-bin
        mkdir qmuxd
        cp -R ${BD}/tmp/work/armv7a-vfp-neon-poky-linux-gnueabi/qmi/${version}/qmi/qmuxd/start_qmuxd_le qmuxd/
    fi

    # Package up the bzip file
    cd /tmp
    tar cjf ${package}-bin.tar.bz2 ${package}-bin
    cd ${OD}/recipes/${target}/files
    mv ${package}-bin.tar.bz2 ${package}-bin.tar.bz2.old
    mv /tmp/${package}-bin.tar.bz2 ${package}-bin.tar.bz2
}

scriptdir=$(cd $(dirname ${0}); pwd)

if [ $# = 0 ]; then
    usage_and_exit 1
fi

while getopts "o:b:v:" arg
do
    case $arg in
    o)
        OD=$(readlink -f $OPTARG)
        echo "Output dir: $OD"
        ;;
    b)
        BD=$(readlink -f $OPTARG)
        echo "Build dir: $BD"
        ;;
    v)
        VER=$OPTARG
        echo "Firmware version: $VER"
        ;;
    ?)
        echo "$0: invalid option -$OPTARG" 1>&2
        usage_and_exit 1
        ;;
    esac
done

setup_dirs
package_basic acdbloader git-r1 true
package_basic acdbmapper git-r1 true
package_basic alsa-intf 1.0-r0 false
package_basic audcal git-r1 true
package_basic audcaltests git-r1 false
package_basic audio-ftm git-r1 false
package_basic audioalsa git-r1 true
package_basic csd-server git-r1 false
package_basic cxm-apps git-r1 false
package_basic configdb git-r4 false data
package_basic data git-r8 false
package_basic dsutils git-r4 true data
package_basic diag git-r6 true
package_basic diag-reboot-app git-r2 false
package_basic loc-api git-r3 false
package_basic mbim git-r0 false
package_basic qmi git-r7 true
package_basic qmi-framework git-r3 true
package_basic sierra git-r0 false
package_basic time-services git-r2 false
package_basic xmllib git-r7 true

cd ${scriptdir}
mv meta-swi-bin meta-swi-bin.old
mv ${OD} meta-swi-bin

echo $VER > meta-swi-bin/fw-version

echo "Layer created"
exit 0
