DESCRIPTION = "Coex Binary Apps"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r1"
RDEPENDS_${PN} = "qmi-framework"

S= "${WORKDIR}/cxm-apps-bin"

SRC_URI = "file://cxm-apps-bin.tar.bz2"

do_install_append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/usr/bin/cxmapp ${D}${bindir}
}

