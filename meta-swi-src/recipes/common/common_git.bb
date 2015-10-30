DESCRIPTION = "Common headers"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"

PR = "r5"

ALLOW_EMPTY_${PN} = "1"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"
SRC_URI = "file://common/inc/"

S = "${WORKDIR}/common/inc"

do_install () {
        install -d ${D}${includedir}
        install -m 0644 ${S}/armasm.h ${D}${includedir}/
        install -m 0644 ${S}/comdef.h ${D}${includedir}/
        install -m 0644 ${S}/customer.h ${D}${includedir}/
        install -m 0644 ${S}/stringl.h ${D}${includedir}/
        install -m 0644 ${S}/target.h ${D}${includedir}/
        [ -e "${S}/common_log.h" ] && install -m 0644 ${S}/common_log.h ${D}${includedir}/
        [ -e "${S}/rex.h" ] && install -m 0644 ${S}/rex.h ${D}${includedir}/
}

inherit proprietary-qcom

