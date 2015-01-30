DESCRIPTION = "Implement a simple EPOLLWAKEUP for monitoring the USB connection"
LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=815ca599c9df247a0c7f619bab123dad"
PR="r1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "file://epollwakeup.c"
SRC_URI += "file://COPYING"

S = "${WORKDIR}"

do_compile() {
    ${CC} epollwakeup.c -o epollwakeup
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 epollwakeup ${D}${bindir}
}

