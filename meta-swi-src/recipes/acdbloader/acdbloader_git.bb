inherit autotools

DESCRIPTION = "acdb loader Library"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
DEPENDS = "glib-2.0 acdbmapper audcal linux-yocto"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/mm-audio/audio-acdb-util/:"

SRC_URI = "file://acdb-loader"
S = "${WORKDIR}/acdb-loader"

inherit proprietary-qcom

# msm-adie-codec.h should be staged so we can reach it. For some reason it isn't so force a copy
# to a place we can use it.
addtask get_adie_include before do_compile
do_get_adie_include() {
    mkdir -p ${WORKDIR}/acdb-loader/linux/mfd/
    cp ${WORKSPACE}/kernel/include/linux/mfd/msm-adie-codec.h ${WORKDIR}/acdb-loader/linux/mfd/
}

do_install_append(){
    install -d ${D}${sysconfdir}/firmware/wcd9310
    ln -sf /data/misc/audio/wcd9310_anc.bin  ${D}${sysconfdir}/firmware/wcd9310/wcd9310_anc.bin
    ln -sf /data/misc/audio/mbhc.bin  ${D}${sysconfdir}/firmware/wcd9310/wcd9310_mbhc.bin
}

EXTRA_OECONF += "--with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                 --with-glib"
