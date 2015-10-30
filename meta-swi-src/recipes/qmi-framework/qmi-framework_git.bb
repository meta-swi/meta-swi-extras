inherit autotools pkgconfig

DESCRIPTION = "QMI Framework Library"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
PR = "r3"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://qmi-framework"

DEPENDS = "qmi"

EXTRA_OECONF = "--with-qmux-libraries=${STAGING_LIBDIR}"

S = "${WORKDIR}/qmi-framework"

EXTRA_OEMAKE = "INCLUDES='-I${S}/{inc,qcci/inc,common/inc,smem_log,qcsi/inc}'"

inherit proprietary-qcom

