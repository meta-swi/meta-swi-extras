DESCRIPTION = "acdb loader Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
DEPENDS = "glib-2.0 acdbmapper audcal"

SRC_URI = "file://acdbloader-bin.tar.bz2"
S = "${WORKDIR}/acdbloader-bin"

do_install_append(){
    install -d ${D}${sysconfdir}/firmware/wcd9310
    ln -sf /data/misc/audio/wcd9310_anc.bin  ${D}${sysconfdir}/firmware/wcd9310/wcd9310_anc.bin
    ln -sf /data/misc/audio/mbhc.bin  ${D}${sysconfdir}/firmware/wcd9310/wcd9310_mbhc.bin
    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}
}
