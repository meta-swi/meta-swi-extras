DESCRIPTION = "Reboot Diag"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
PR = "r2"
DEPENDS = "glib-2.0 diag qmi"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://diag-reboot-app"

inherit autotools

S = "${WORKDIR}/diag-reboot-app"

EXTRA_OECONF += "--with-glib --with-common-includes=${STAGING_INCDIR}"

INITSCRIPT_NAME = "diagrebootapp"

inherit update-rc.d

do_install_append() {
        install -m 0755 ${WORKDIR}/diag-reboot-app/start_diagrebootapp -D ${D}${sysconfdir}/init.d/diagrebootapp
}

pkg_postinst_${PN} () {
        [ -n "$D" ] && OPT="-r $D" || OPT="-s"
        update-rc.d $OPT -f diagrebootapp remove
        update-rc.d $OPT diagrebootapp start 25 S . stop 75 S .
}


inherit proprietary-qcom

