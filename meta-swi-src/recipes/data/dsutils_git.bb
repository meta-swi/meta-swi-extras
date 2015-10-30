inherit autotools pkgconfig

DESCRIPTION = "Qualcomm Data DSutils Module"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "common diag glib-2.0"
PR = "r4"

EXTRA_OECONF = "--with-lib-path=${STAGING_LIBDIR} \
                --with-common-includes=${STAGING_INCDIR} \
                --with-glib \
                --with-qxdm"

EXTRA_OEMAKE = "INCLUDES='-I${S}/inc'"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/data:"

SRC_URI = "file://dsutils"

S = "${WORKDIR}/dsutils"

inherit proprietary-qcom

