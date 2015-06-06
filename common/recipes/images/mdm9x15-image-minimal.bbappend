IMAGE_INSTALL_append += " system-core-adbd"
IMAGE_INSTALL_append += " system-core-usb"
IMAGE_INSTALL_append += " system-core-liblog"
IMAGE_INSTALL_append += " system-core-libcutils"
require 9615-cdp-qcom-image.inc
require 9615-cdp-sierra-image.inc

DEPENDS += "cwetool-native"

generate_cwe_pid() {
    PID=$1
    PAGE_SIZE=$2
    OUTPUT=$3
    BOOT_IMAGE=$4
    LEGATO_IMAGE=$5

    KERNEL_IMG="${DEPLOY_DIR_IMAGE}/boot-yocto-mdm9x15.$PAGE_SIZE.img"
    ROOTFS_IMG="${DEPLOY_DIR_IMAGE}/mdm9x15-image-minimal-swi-mdm9x15.$PAGE_SIZE.yaffs2"

    unset LK_IMG
    unset LK_OPT

    unset LEGATO_IMG
    unset LEGATO_OPT

    if [[ "$BOOT_IMAGE" == "true" ]]; then
        LK_IMG=$(readlink -f ${DEPLOY_DIR_IMAGE}/appsboot.mbn)

        echo "Bootloader: $LK_IMG"
        LK_OPT="-fbt"
    fi

    echo "Kernel: $KERNEL_IMG"
    echo "Rootfs: $ROOTFS_IMG"

    if [[ "$LEGATO_IMAGE" == "true" ]]; then
        LEGATO_IMG=$(readlink -f ${DEPLOY_DIR_IMAGE}/legato-image.$TARGET.yaffs2)

        echo "Legato: $LEGATO_IMG"
        LEGATO_OPT="-ufs"
    fi

    yoctocwetool.sh \
        -pid $PID \
        -z \
        -o $OUTPUT \
        $LK_OPT $LK_IMG \
        -kernel $KERNEL_IMG \
        -rfs $ROOTFS_IMG \
        $LEGATO_OPT $LEGATO_IMG
}

generate_cwe_target() {
    TARGET=$1

    PAGE_SIZE=4k

    case $TARGET in
        ar7)    PID='A911' ;;
        ar86)   PID='A911' ;;
        wp7)    PID='9X15' ;;
        wp85)   PID='Y912'
                PAGE_SIZE=2k ;;
        *)
            echo "Unknown product '$TARGET'"
            exit 1
        ;;
    esac

    echo "Generating CWE package for $TARGET ($PAGE_SIZE)"
    generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/yocto_$TARGET.cwe false false

    echo "Generating CWE package for $TARGET ($PAGE_SIZE, with lk)"
    generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/boot-yocto_$TARGET.cwe true false

    if [[ "${LEGATO_BUILD}" == "true" ]]; then
        echo "Generating CWE package for $TARGET ($PAGE_SIZE)"
        generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/yocto-legato_$TARGET.cwe false true

        echo "Generating CWE package for $TARGET ($PAGE_SIZE, with lk, with Legato)"
        generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/boot-yocto-legato_$TARGET.cwe true true
    fi
}

# Only depend on legato-image if this is a LEGATO_BUILD
def check_legato_dep(d):
    legato_build = d.getVar('LEGATO_BUILD', True) or False
    if legato_build:
        return "legato-image:do_install"
    return ""

do_generate_cwe[depends]  = "${@check_legato_dep(d)}"
do_generate_cwe[depends] += "cwetool-native:do_populate_sysroot"
do_generate_cwe[depends] += "${PN}:do_install"
do_generate_cwe[depends] += "${PN}:do_rootfs"

do_generate_cwe() {
    for target in ${LEGATO_ROOTFS_TARGETS}; do
        generate_cwe_target $target
    done
}

addtask generate_cwe before do_build

