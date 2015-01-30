inherit autotools

DESCRIPTION = "Qualcomm Data Configdb Module"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "common dsutils diag xmllib glib-2.0"
PR = "r4"

EXTRA_OECONF = "--with-lib-path=${STAGING_LIBDIR} \
                --with-common-includes=${STAGING_INCDIR} \
                --with-glib \
                --with-qxdm"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/data:"

SRC_URI = "file://configdb"

S = "${WORKDIR}/configdb"

inherit proprietary-qcom

