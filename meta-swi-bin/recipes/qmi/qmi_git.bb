DESCRIPTION = "Qualcomm MSM Interface (QMI) Library"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"

PR = "r7"

DEPENDS = "configdb diag"

SRC_URI = "file://qmi-bin.tar.bz2"

S = "${WORKDIR}/qmi-bin"

INITSCRIPT_NAME = "qmuxd"
INITSCRIPT_PARAMS = "start 30 S . stop 70 S ."

inherit update-rc.d

do_install_append() {
    install -m 0755 ${S}/etc/init.d/qmuxd -D ${D}${sysconfdir}/init.d/qmuxd
    install -m 0755 ${S}/etc/init.d/start_qmuxd -D ${D}${sysconfdir}/init.d/start_qmuxd

    # Copy the /usr tree across for imaging
    cp -R --preserve=links ${S}/usr ${D}
    chmod 0644 ${D}/usr/lib/*
}
