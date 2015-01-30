IMAGE_INSTALL_append += " system-core-adbd"
IMAGE_INSTALL_append += " system-core-usb"
IMAGE_INSTALL_append += " system-core-liblog"
IMAGE_INSTALL_append += " system-core-libcutils"
require 9615-cdp-qcom-image.inc
require 9615-cdp-sierra-image.inc

DEPENDS += "cwetool-native"

generate_cwe_pid() {
    PID=$1
    OUTPUT=$2
    LEGATO_IMAGE=$3

    if [ -n "$LEGATO_IMAGE" ]; then
        LEGATO_OPT="-ufs $LEGATO_IMAGE"
    fi

    yoctocwetool.sh \
        -pid $PID \
        -o $OUTPUT \
        -fbt ${DEPLOY_DIR_IMAGE}/appsboot.mbn \
        -kernel ${DEPLOY_DIR_IMAGE}/kernel \
        -rfs ${DEPLOY_DIR_IMAGE}/rootfs \
        ${LEGATO_OPT}
}

# Only depend on legato-af if this is a LEGATO_BUILD
def check_legato_dep(d):
    legato_build = d.getVar('LEGATO_BUILD', True) or False
    if legato_build:
        return "legato-af:do_install"
    return ""

do_generate_cwe[depends]  = "${@check_legato_dep(d)}"
do_generate_cwe[depends] += "cwetool-native:do_populate_sysroot"
do_generate_cwe[depends] += "${PN}:do_install"
do_generate_cwe[depends] += "${PN}:do_rootfs"

do_generate_cwe() {
    echo "Generate CWE package for WP7"
    generate_cwe_pid '9X15' ${DEPLOY_DIR_IMAGE}/yocto_wp7.cwe

    echo "Generate CWE package for AR7"
    generate_cwe_pid 'A911' ${DEPLOY_DIR_IMAGE}/yocto_ar7.cwe

    echo "Generate CWE package for AR86"
    generate_cwe_pid 'A911' ${DEPLOY_DIR_IMAGE}/yocto_ar86.cwe

    if [[ "${LEGATO_BUILD}" == "true" ]]; then
        echo "Generate CWE package for WP7 (with Legato)"
        generate_cwe_pid '9X15' ${DEPLOY_DIR_IMAGE}/yocto-legato_wp7.cwe ${DEPLOY_DIR_IMAGE}/legato_af_wp7.yaffs2

        echo "Generate CWE package for AR7 (with Legato)"
        generate_cwe_pid 'A911' ${DEPLOY_DIR_IMAGE}/yocto-legato_ar7.cwe ${DEPLOY_DIR_IMAGE}/legato_af_ar7.yaffs2

        echo "Generate CWE package for AR86 (with Legato)"
        generate_cwe_pid 'A911' ${DEPLOY_DIR_IMAGE}/yocto-legato_ar86.cwe ${DEPLOY_DIR_IMAGE}/legato_af_ar86.yaffs2
    fi
}

addtask generate_cwe before do_build

