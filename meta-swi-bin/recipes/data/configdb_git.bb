DESCRIPTION = "Qualcomm Data Configdb Module"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
DEPENDS = "dsutils diag xmllib glib-2.0"
PR = "r4"

SRC_URI = "file://configdb-bin.tar.bz2"
S = "${WORKDIR}/configdb-bin"

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
}
