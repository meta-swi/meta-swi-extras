SUMMARY = "Library for Seminole Web Server"
DESCRIPTION = "Used for WebUI application server"
HOMEPAGE = "http://www.gladesoft.com"
SECTION = "libs"
DEPENDS = ""
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=bf3340e378ed7c8ac19df2de203162e6"
PR = "r1"

SRC_URI = "file://seminole-bin.tar.bz2"

S = "${WORKDIR}/seminole-bin"

do_install() {
    cp -R --preserve=links ${S}/usr ${D}
}

ALLOW_EMPTY_${PN} = "1"