DESCRIPTION = "Library and routing applications for diagnostic traffic"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
DEPENDS = "glib-2.0 system-core"

PR = "r6"

SRC_URI = "file://diag-bin.tar.bz2 \
           file://chgrp-diag"

S = "${WORKDIR}/diag-bin"

INITSCRIPT_NAME = "chgrp-diag"
INITSCRIPT_PARAMS = "start 15 2 3 4 5 ."

inherit update-rc.d

do_install_append() {
    install -m 0755 ${WORKDIR}/chgrp-diag -D ${D}${sysconfdir}/init.d/chgrp-diag
    cp -R --preserve=links ${S}/usr ${D}
}
