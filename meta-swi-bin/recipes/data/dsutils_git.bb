DESCRIPTION = "Qualcomm Data DSutils Module"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r4"

DEPENDS = "diag glib-2.0"

SRC_URI = "file://dsutils-bin.tar.bz2"
S = "${WORKDIR}/dsutils-bin"

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
}
