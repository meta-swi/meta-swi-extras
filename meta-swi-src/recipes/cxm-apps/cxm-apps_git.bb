DESCRIPTION = "Coex Apps"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
PR = "r1"
DEPENDS = "qmi-framework"
RDEPENDS_${PN} = "qmi-framework"

S= "${WORKDIR}/cxm-apps"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://cxm-apps"

inherit autotools

inherit proprietary-qcom

