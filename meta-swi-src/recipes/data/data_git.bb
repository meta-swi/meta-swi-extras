inherit autotools pkgconfig

DESCRIPTION = "Qualcomm Data Modules (Excluding ConfigDB and DSUtils)"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
PR = "r8"

DEPENDS = "diag dsutils glib-2.0 qmi qmi-framework xmllib linux-yocto"

EXTRA_OECONF = "--with-lib-path=${STAGING_LIBDIR} \
                --with-common-includes=${STAGING_INCDIR} \
                --with-glib \
                --with-qxdm \
                --enable-target=9615-cdp \
                WORKSPACE="${WORKSPACE}" \
                "
export GLIB_LIBS="-lrt"

EXTRA_OEMAKE = " WORKSPACE=${WORKSPACE} "

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = " \
            file://data \
            file://data-init \
            "

S = "${WORKDIR}/data"

# DM, FIXME: There are two ps_svc.h files:
#     dss_new/src/platform/inc/ps_svc.h
#     dss_new/inc/ps_svc.h
# ${srcdir}/../inc should resolve it all, but it does not, because
# dss_new/src/platform/inc/ps_svc.h never gets included. Later contains
# ps_set_cmd_handler and ps_send_cmd methods which need to be in one of the
# so libs. The real question is, if incorrect content could be delivered
# to the compiled file (dss_new/src/platform/inc/ps_svc.h would always
# resolve first).
EXTRA_OEMAKE += "INCLUDES='-I${S}/dss_new/src/platform/inc -I${srcdir}/../inc -I${S}/dsi_netctrl/inc -I${S}/netmgr/inc/ -I${S}/qdi/inc/'"

FILES_${PN}-dbg += "/tmp/tests/.debug"
FILES_${PN} += "/tmp"

inherit proprietary-qcom

pkg_postinst_${PN} () {
        [ -n "$D" ] && OPT="-r $D" || OPT="-s"
        update-rc.d $OPT -f netmgrd remove
        update-rc.d $OPT netmgrd start 45 S . stop 55 S .

        # DM, FIXME: This should become part of iptables
        # and connection tracking suite.
        update-rc.d $OPT -f data-init remove
        update-rc.d $OPT data-init start 97 S

        update-rc.d $OPT -f qti remove
        update-rc.d $OPT qti start 20 S . stop 80 S .

        update-rc.d $OPT -f QCMAP_ConnectionManager remove
        update-rc.d $OPT QCMAP_ConnectionManager start 30 S . stop 30 S .
}

do_install_append() {
        install -m 0755 ${WORKDIR}/data/netmgr/src/start_netmgrd_le -D ${D}${sysconfdir}/init.d/netmgrd
        install -m 0755 ${WORKDIR}/data/netmgr/src/udhcpc.script -D ${D}${sysconfdir}/udhcpc.d/udhcpc.script
        install -m 0755 ${WORKDIR}/data/mobileap/src/mobileap_cfg.xml -D ${D}${sysconfdir}/mobileap_cfg.xml
        install -m 0755 ${WORKDIR}/data/mobileap/src/mobileap_cfg.xsd -D ${D}${sysconfdir}/mobileap_cfg.xsd
        install -m 0755 ${WORKDIR}/data-init -D ${D}${sysconfdir}/init.d/data-init
        install -m 0755 ${WORKDIR}/data/mobileap/src/start_QCMAP_ConnectionManager_le -D ${D}${sysconfdir}/init.d/QCMAP_ConnectionManager
        install -m 0755 ${WORKDIR}/data/qti/src/start_qti_le -D ${D}${sysconfdir}/init.d/qti
}

sysroot_stage_all_append() {
    sysroot_stage_dir ${D}/tmp ${SYSROOT_DESTDIR}${STAGING_DIR_HOST}/tmp
}

