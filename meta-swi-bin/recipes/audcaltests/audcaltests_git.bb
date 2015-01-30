DESCRIPTION = "Audio Caliberation Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
DEPENDS = "glib-2.0 audioalsa acdbmapper acdbloader"

SRC_URI = "file://audcaltests-bin.tar.bz2"

S = "${WORKDIR}/audcaltests-bin"

do_install_append(){
    cp -R --preserve=links ${S}/usr ${D}
}

