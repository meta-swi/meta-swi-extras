DESCRIPTION = "CSD QMI Server"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"

DEPENDS = "glib-2.0 qmi-framework acdbloader alsa-intf"

SRC_URI = "file://csd-server-bin.tar.bz2"

S = "${WORKDIR}/csd-server-bin"

#
# DM, FIXME: I am disabling this bellow to match recipe result in meta-swi-src. If startup (S/K)
# links become available in meta-swi-src, make sure these are enabled here as well.
#
#INITSCRIPT_NAME = "csdserver"
#INITSCRIPT_PARAMS = "start 45 S . stop 55 S ."

# If this is enabled and INITSCRIPT_PARAMS is not, rc0.d - rc6.d directories will be created and
# S/K csdserver links will show up in every one of them.
#inherit update-rc.d

do_install_append(){
    install -m 0755 ${S}/etc/init.d/csdserver -D ${D}${sysconfdir}/init.d/csdserver

    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}
}

