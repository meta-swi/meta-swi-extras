DESCRIPTION = "Qualcomm XML Library"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
DEPENDS = "diag glib-2.0"
PR = "r7"

SRC_URI = "file://xmllib-bin.tar.bz2"
S = "${WORKDIR}/xmllib-bin"

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
}

