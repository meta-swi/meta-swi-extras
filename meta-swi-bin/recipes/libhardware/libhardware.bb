DESCRIPTION = "hardware abstraction library to load hardware modules"
HOMEPAGE = "http://codeaurora.org/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r4"

SRC_URI = "file://libhardware.tar.bz2"
SRC_URI += "file://autotools.patch"

S = "${WORKDIR}/${PN}"

DEPENDS = "system-core"

inherit autotools

EXTRA_OEMAKE = "INCLUDES='-I${WORKDIR}/libhardware/include'"

do_install_append () {
        install -d ${D}${includedir}
        install -m 0644 ${S}/include/hardware/gps.h -D ${D}${includedir}/hardware/gps.h
        install -m 0644 ${S}/include/hardware/hardware.h -D ${D}${includedir}/hardware/hardware.h
        install -m 0644 ${S}/include/hardware/gralloc.h -D ${D}${includedir}/hardware/gralloc.h
}
