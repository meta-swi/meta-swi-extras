inherit autotools pkgconfig
DESCRIPTION = "Audio FTM"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "common glib-2.0 alsa-intf"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/mm-audio/:"

SRC_URI = "file://audio_ftm"
S = "${WORKDIR}/audio_ftm"
EXTRA_OECONF += "--with-common-includes=${STAGING_INCDIR} \
                 --with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                 --with-glib"

EXTRA_OEMAKE = " INCLUDES='-I${S}/inc' "

inherit proprietary-qcom

