DESCRIPTION = "Reboot Diag"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r2"
DEPENDS = "glib-2.0 diag qmi"

SRC_URI = "file://diag-reboot-app-bin.tar.bz2"

S = "${WORKDIR}/diag-reboot-app-bin"

INITSCRIPT_NAME = "diagrebootapp"

inherit update-rc.d

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}

}

pkg_postinst_${PN} () {
        [ -n "$D" ] && OPT="-r $D" || OPT="-s"
        update-rc.d $OPT -f diagrebootapp remove
        update-rc.d $OPT diagrebootapp start 25 S . stop 75 S .
}

