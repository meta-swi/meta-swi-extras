inherit autotools

DESCRIPTION = "Qualcomm XML Library"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "common diag glib-2.0"
PR = "r7"

EXTRA_OECONF = "--with-common-includes=${STAGING_INCDIR} \
                --with-glib \
                --with-qxdm"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://xmllib"
S = "${WORKDIR}/xmllib"

inherit proprietary-qcom

