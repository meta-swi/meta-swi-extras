DESCRIPTION = "Time Services Daemon"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r2"

SRC_URI = "file://time-services-bin.tar.bz2"

DEPENDS = "qmi-framework"
RDEPENDS_${PN} = "qmi-framework"

S = "${WORKDIR}/time-services-bin"

# install only time_serviced. It will be called by time_services.
do_install_append(){
    cp -R --preserve=links ${S}/usr ${D}
#   cp -R --preserve=links ${S}/etc ${D}
    mkdir -p ${D}/etc/init.d
    cp -R --preserve=links ${S}/etc/init.d ${D}/etc/
    chmod 0755 ${D}${sysconfdir}/init.d/time_serviced
}

