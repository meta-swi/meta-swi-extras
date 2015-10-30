inherit autotools pkgconfig

DESCRIPTION = "Library and routing applications for diagnostic traffic"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "common glib-2.0 system-core"

PR = "r6"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://diag \
           file://chgrp-diag"

S = "${WORKDIR}/diag"

EXTRA_OECONF += "--with-glib \
                 --with-common-includes=${STAGING_INCDIR}"

EXTRA_OEMAKE = "INCLUDES='-I${S}/include -I${S}/src'"

INITSCRIPT_NAME = "chgrp-diag"
INITSCRIPT_PARAMS = "start 95 S ."

inherit proprietary-qcom

inherit update-rc.d

do_install_append() {
    install -m 0755 ${WORKDIR}/chgrp-diag -D ${D}${sysconfdir}/init.d/chgrp-diag
}

