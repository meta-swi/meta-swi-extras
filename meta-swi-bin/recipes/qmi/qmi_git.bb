DESCRIPTION = "Qualcomm MSM Interface (QMI) Library"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"

PR = "r7"

DEPENDS = "configdb diag"

SRC_URI = "file://qmi-bin.tar.bz2"

S = "${WORKDIR}/qmi-bin"

INITSCRIPT_NAME = "qmuxd"
INITSCRIPT_PARAMS = "start 40 S . stop 60 S ."

inherit update-rc.d

do_install_append() {
    install -m 0755 ${WORKDIR}/qmi-bin/qmuxd/start_qmuxd_le -D ${D}${sysconfdir}/init.d/qmuxd

    # Copy the /usr tree across for imaging
    cp -R --preserve=links ${S}/usr ${D}
    chmod 0644 ${D}/usr/lib/*
}
