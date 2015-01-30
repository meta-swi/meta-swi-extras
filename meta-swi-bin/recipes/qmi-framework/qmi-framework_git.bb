DESCRIPTION = "QMI Framework Library"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r3"

SRC_URI = "file://qmi-framework-bin.tar.bz2"

DEPENDS = "qmi"

S = "${WORKDIR}/qmi-framework-bin"

do_install_append() {
    # Copy the /usr tree across for imaging
    cp -R --preserve=links ${S}/usr ${D}
    chmod 0644 ${D}/usr/lib/*
}

