DESCRIPTION = "Qualcomm Data Modules (Excluding ConfigDB and DSUtils)"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r8"

DEPENDS = "diag dsutils glib-2.0 qmi qmi-framework xmllib"

SRC_URI = " \
            file://data-bin.tar.bz2 \
            "

S = "${WORKDIR}/data-bin"

FILES_${PN}-dbg += "/tmp/tests/.debug"
FILES_${PN} += "/tmp"

pkg_postinst_${PN} () {
        [ -n "$D" ] && OPT="-r $D" || OPT="-s"
        update-rc.d $OPT -f netmgrd remove
        update-rc.d $OPT netmgrd start 45 S . stop 55 S .

        update-rc.d $OPT -f data-init remove
        update-rc.d $OPT data-init start 97 S

        update-rc.d $OPT -f qti remove
        update-rc.d $OPT qti start 20 S . stop 80 S .

        update-rc.d $OPT -f QCMAP_ConnectionManager remove
        update-rc.d $OPT QCMAP_ConnectionManager start 30 S . stop 30 S .
}

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}
    cp -R --preserve=links ${S}/tmp ${D}
}

sysroot_stage_all_append() {
    sysroot_stage_dir ${D}/tmp ${SYSROOT_DESTDIR}${STAGING_DIR_HOST}/tmp
}
