DESCRIPTION = "Qualcomm Data Modules (Excluding ConfigDB and DSUtils)"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"
PR = "r8"

DEPENDS = "diag dsutils glib-2.0 qmi qmi-framework xmllib"

SRC_URI = " \
            file://data-bin.tar.bz2 \
            file://data-init \
            "

S = "${WORKDIR}/data-bin"

FILES_${PN}-dbg += "/tmp/tests/.debug"
FILES_${PN} += "/tmp"

pkg_postinst_${PN} () {
        [ -n "$D" ] && OPT="-r $D" || OPT="-s"
        update-rc.d $OPT -f netmgrd remove
        update-rc.d $OPT netmgrd start 45 2 3 4 5 . stop 80 0 1 6 .

        update-rc.d $OPT -f data-init remove
        update-rc.d $OPT data-init start 97 2 3 4 5 . stop 15 0 1 6 .

        update-rc.d $OPT -f qti remove
        update-rc.d $OPT qti start 20 2 3 4 5 . stop 20 0 1 6 .

        update-rc.d $OPT -f QCMAP_ConnectionManager remove
        update-rc.d $OPT QCMAP_ConnectionManager start 30 2 3 4 5 . stop 30 0 1 6 .
}

do_install_append() {
    cp -R --preserve=links ${S}/usr ${D}
    cp -R --preserve=links ${S}/etc ${D}
    cp -R --preserve=links ${S}/tmp ${D}
}

sysroot_stage_all_append() {
    sysroot_stage_dir ${D}/tmp ${SYSROOT_DESTDIR}${STAGING_DIR_HOST}/tmp
}
