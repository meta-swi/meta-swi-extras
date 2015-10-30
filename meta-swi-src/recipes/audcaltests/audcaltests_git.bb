DESCRIPTION = "Audio Caliberation Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "glib-2.0 audioalsa acdbmapper acdbloader"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/mm-audio/audcal/common/:"

SRC_URI = "file://test"

S = "${WORKDIR}/test"

EXTRA_OECONF += "--with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                 --with-glib"
inherit autotools pkgconfig

inherit proprietary-qcom

