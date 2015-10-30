inherit autotools pkgconfig

DESCRIPTION = "Audio Caliberation Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "glib-2.0 diag common acdbmapper"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/mm-audio/:"

SRC_URI = "file://audcal"

S = "${WORKDIR}/audcal"

EXTRA_OECONF += "--with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                 --with-glib"

EXTRA_OEMAKE = "INCLUDES='-I${srcdir}/../inc -I${srcdir}/../../../8960/acdbdata/inc -I${srcdir}/../../acdbdata/inc -I${srcdir}/../../acph/inc -I${srcdir}/../../audtp/{src,inc} -I${srcdir}/../../actp/inc'"

inherit proprietary-qcom
