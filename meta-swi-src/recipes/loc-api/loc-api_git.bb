inherit autotools

DESCRIPTION = "GPS Location API"
PR = "r3"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=3775480a712fc46a69647678acb234cb"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/hardware/qcom/:"

SRC_URI = "file://gps"
DEPENDS = "qmi-framework glib-2.0 libhardware"

EXTRA_OECONF = "--with-libhardware-includes=${STAGING_INCDIR} \
                --with-core-includes=${WORKSPACE}/system/core/include \
                --with-glib"

S = "${WORKDIR}/gps"

inherit proprietary-qcom

