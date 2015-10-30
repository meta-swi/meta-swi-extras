inherit autotools pkgconfig

DESCRIPTION = "hardware libhardware headers"
HOMEPAGE = "http://codeaurora.org/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r4"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/hardware/:"

SRC_URI = " \
            file://libhardware/ \
            file://autotools.patch \
            "

S = "${WORKDIR}/${PN}"

EXTRA_OEMAKE = "INCLUDES='-I${S}/include'"

DEPENDS = "system-core"

do_install_append () {
        install -d ${D}${includedir}
        install -m 0644 ${S}/include/hardware/gps.h -D ${D}${includedir}/hardware/gps.h
        install -m 0644 ${S}/include/hardware/hardware.h -D ${D}${includedir}/hardware/hardware.h
        install -m 0644 ${S}/include/hardware/gralloc.h -D ${D}${includedir}/hardware/gralloc.h
}

inherit proprietary-qcom

