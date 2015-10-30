inherit autotools pkgconfig

DESCRIPTION = "libaudioalsa Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"

DEPENDS = "glib-2.0 linux-yocto"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://mm-audio/audio-alsa"

S = "${WORKDIR}/audio-alsa"

EXTRA_OEMAKE = "INCLUDES='-I${S}/inc'"

EXTRA_OECONF += "--with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                 --with-glib"

inherit proprietary-qcom

