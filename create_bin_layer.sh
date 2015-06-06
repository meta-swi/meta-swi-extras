#!/bin/bash
#

usage()
{
    cat << EOF
Usage:
$0
    -b <build_dir>
    -o <output_dir (relative to current dir)>
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
    mkdir -p ${OD}
    cp -R meta-swi-bin ${OD}
    echo "Created base output dir ${OD}"
}

check_ret() {
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "Exit Code $RETVAL"
        exit $RETVAL
    fi
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

    package_dir="${BD}/tmp/work/armv7a-vfp-neon-poky-linux-gnueabi/${package}/${version}"

    if ! [ -e "$package_dir" ]
    then
        echo "'$package_dir' doesn't exist"
        exit 1
    fi

    cp -R ${package_dir}/image/* /tmp/${package}-bin

    # Copy the license file into place
    if [ ${package} != "sierra" ]
    then
        cp ${OD}/meta-swi-bin/recipes/LICENSE /tmp/${package}-bin
        check_ret
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

    mkdir -p ${OD}/meta-swi-bin/recipes/${target}/files
    cd ${OD}/meta-swi-bin/recipes/${target}/files
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
echo $VER > ${OD}/meta-swi-bin/fw-version

package_basic acdbloader git-r1 true
package_basic acdbmapper git-r1 true
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
rm -rf meta-swi-bin
mv ${OD}/meta-swi-bin meta-swi-bin
rm -rf ${OD}


echo "Layer created"
exit 0

