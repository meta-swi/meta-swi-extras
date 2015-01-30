DESCRIPTION = "ALSA Framework Library"
LICENSE = "Apache-2.0"
PR = "r3"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
DEPENDS = "virtual/kernel acdbloader glib-2.0"

SRC_URI = "file://alsa-intf-bin.tar.bz2"
prefix="/etc"

S = "${WORKDIR}/alsa-intf-bin"

FILES_${PN} += "${prefix}/snd_soc_msm/*"

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}
}

