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
    KERNEL_IMAGE=$5
    ROOTFS_IMAGE=$6
    LEGATO_IMAGE=$7

    unset KERNEL_IMG
    unset KERNEL_OPT

    unset ROOTFS_IMG
    unset ROOTFS_OPT

    unset LK_IMG
    unset LK_OPT

    unset LEGATO_IMG
    unset LEGATO_OPT

    if [[ "$BOOT_IMAGE" == "true" ]]; then
        LK_IMG=$(readlink -f ${DEPLOY_DIR_IMAGE}/appsboot.mbn)

        echo "Bootloader: $LK_IMG"
        LK_OPT="-fbt"
    fi

    if [[ "$KERNEL_IMAGE" == "true" ]]; then
        KERNEL_IMG="${DEPLOY_DIR_IMAGE}/boot-yocto-mdm9x15.${PAGE_SIZE}.img"

        echo "Kernel: $KERNEL_IMG"
        KERNEL_OPT="-kernel"
    fi

    if [[ "$ROOTFS_IMAGE" == "true" ]]; then
        ROOTFS_IMG="${DEPLOY_DIR_IMAGE}/mdm9x15-image-minimal-swi-mdm9x15.${PAGE_SIZE}.default"
        if ! [ -e "$ROOTFS_IMG" ]; then
            ROOTFS_IMG="${DEPLOY_DIR_IMAGE}/mdm9x15-image-minimal-swi-mdm9x15.${PAGE_SIZE}.yaffs2"
        fi

        echo "Rootfs: $ROOTFS_IMG"
        ROOTFS_OPT="-rfs"
    fi

    if [[ "$LEGATO_IMAGE" == "true" ]]; then
        LEGATO_IMG=$(readlink -f ${DEPLOY_DIR_IMAGE}/legato-image.${TARGET}.default)
        if ! [ -e "$LEGATO_IMG" ]; then
            LEGATO_IMG=$(readlink -f ${DEPLOY_DIR_IMAGE}/legato-image.${TARGET}.yaffs2)
        fi

        echo "Legato: $LEGATO_IMG"
        LEGATO_OPT="-ufs"
    fi

    yoctocwetool.sh \
        -pid $PID \
        -z \
        -o $OUTPUT \
        $LK_OPT $LK_IMG \
        $KERNEL_OPT $KERNEL_IMG \
        $ROOTFS_OPT $ROOTFS_IMG \
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

    echo "Generating CWE package for $TARGET (just lk)"
    generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/boot_$TARGET.cwe true false false false

    echo "Generating CWE package for $TARGET ($PAGE_SIZE)"
    generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/yocto_$TARGET.cwe false true true false

    echo "Generating CWE package for $TARGET ($PAGE_SIZE, with lk)"
    generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/boot-yocto_$TARGET.cwe true true true false

    if [[ "${LEGATO_BUILD}" == "true" ]]; then
        echo "Generating CWE package for $TARGET ($PAGE_SIZE)"
        generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/yocto-legato_$TARGET.cwe false true true true

        echo "Generating CWE package for $TARGET ($PAGE_SIZE, with lk, with Legato)"
        generate_cwe_pid $PID $PAGE_SIZE ${DEPLOY_DIR_IMAGE}/boot-yocto-legato_$TARGET.cwe true true true true
    fi
}

# Only depend on legato-image if this is a LEGATO_BUILD
def check_legato_dep(d):
    legato_build = d.getVar('LEGATO_BUILD', True) or "false"
    if legato_build == "true":
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

