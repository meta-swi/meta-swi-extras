inherit autotools

DESCRIPTION = "CSD QMI Server"
LICENSE = "QUALCOMM-Proprietary"
PR = "r1"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"

DEPENDS = "glib-2.0 qmi-framework acdbloader alsa-intf linux-yocto"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/mm-audio/audio-qmi/:"
SRC_URI = "file://csd-server"

S = "${WORKDIR}/csd-server"

EXTRA_OECONF += "--with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                 --with-glib"

#INITSCRIPT_NAME = "csdserver"
#INITSCRIPT_PARAMS = "start 45 2 3 4 5 . stop 80 0 1 6 ."

#inherit update-rc.d

#do_install_append(){
#    install -m 0755 ${S}/etc/init.d/csdserver -D ${D}${sysconfdir}/init.d/csdserver
#
#    cp -R --preserve=links ${S}/usr ${D}
#    cp -R --preserve=links ${S}/etc ${D}
#}

inherit proprietary-qcom

