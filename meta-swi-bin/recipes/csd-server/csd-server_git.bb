DESCRIPTION = "CSD QMI Server"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"

DEPENDS = "glib-2.0 qmi-framework acdbloader alsa-intf"

SRC_URI = "file://csd-server-bin.tar.bz2"

S = "${WORKDIR}/csd-server-bin"

INITSCRIPT_NAME = "csdserver"
INITSCRIPT_PARAMS = "start 45 2 3 4 5 . stop 80 0 1 6 ."

inherit update-rc.d

do_install_append(){
    install -m 0755 ${S}/etc/init.d/csdserver -D ${D}${sysconfdir}/init.d/csdserver

    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}
}

