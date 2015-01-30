inherit autotools

DESCRIPTION = "acdb mapper Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "glib-2.0 audioalsa"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/mm-audio/audio-acdb-util/:"

SRC_URI = "file://acdb-mapper"
S = "${WORKDIR}/acdb-mapper"

EXTRA_OECONF += "--with-sanitized-headers=${STAGING_KERNEL_HEADERS} \
                 --with-glib"

inherit proprietary-qcom

