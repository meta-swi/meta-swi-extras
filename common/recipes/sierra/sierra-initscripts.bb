DESCRIPTION = "Sierra Wireless Initialization"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://../swiapplaunch.sh;startline=2;endline=2;md5=22dcb8c37cc7ca6b4aad807c89ffc0d5"

DEPENDS = "sierra"

SRC_URI = "file://confighw.sh \
           file://swiapplaunch.sh \
           file://varrw.sh \
           file://restart_swi_apps \
           file://start_dbi_daemon \
           file://restartNMEA \
           file://run.env \
           file://run_getty.sh \
           file://enable_autosleep.sh \
           file://time_services/time_services \
           file://time_services/ntpd_time_service \
           file://time_services/ntpd_start \
           file://time_services/ntpd_stop \
           file://time_services/time_service.conf \
          "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
    install -m 0755 ${WORKDIR}/confighw.sh -D ${D}${sysconfdir}/init.d/confighw.sh
    install -m 0755 ${WORKDIR}/swiapplaunch.sh -D ${D}${sysconfdir}/init.d/swiapplaunch.sh
    install -m 0755 ${WORKDIR}/varrw.sh -D ${D}${sysconfdir}/init.d/varrw.sh
    install -m 0755 ${WORKDIR}/restart_swi_apps -D ${D}${sbindir}/restart_swi_apps
    install -m 0755 ${WORKDIR}/start_dbi_daemon -D ${D}${sysconfdir}/init.d/start_dbi_daemon
    install -m 0755 ${WORKDIR}/restartNMEA -D ${D}${sbindir}/restartNMEA
    install -m 0444 ${WORKDIR}/run.env -D ${D}${sysconfdir}/run.env
    install -m 0755 ${WORKDIR}/run_getty.sh -D ${D}${sysconfdir}/init.d/run_getty.sh
    install -m 0755 ${WORKDIR}/enable_autosleep.sh -D ${D}${sysconfdir}/init.d/enable_autosleep.sh
    install -D -m 0755 ${WORKDIR}/time_services/time_services -D ${D}${sysconfdir}/init.d/time_services
    install -D -m 0755 ${WORKDIR}/time_services/ntpd_time_service -D ${D}${sysconfdir}/init.d/ntpd_time_service
    install -D -m 0755 ${WORKDIR}/time_services/ntpd_stop -D ${D}${sysconfdir}/network/if-down.d/ntpd_stop
    install -D -m 0755 ${WORKDIR}/time_services/ntpd_start -D ${D}${sysconfdir}/network/if-up.d/ntpd_start
    install -D -m 0644 ${WORKDIR}/time_services/time_service.conf -D ${D}${sysconfdir}/etc/time_service.conf

    [ -n "${D}" ] && OPT="-r ${D}" || OPT="-s"
    update-rc.d $OPT -f confighw.sh remove
    update-rc.d $OPT confighw.sh start 02 S 2 3 4 5 . stop 98 0 1 6 .
    update-rc.d $OPT -f swiapplaunch.sh remove
    update-rc.d $OPT swiapplaunch.sh start 90 2 3 4 5 . stop 02 S 0 1 6 .
    update-rc.d $OPT -f varrw.sh remove
    update-rc.d $OPT varrw.sh start 36 S . stop 99 0 6 .
    update-rc.d $OPT -f start_dbi_daemon remove
    update-rc.d $OPT start_dbi_daemon start 99 2 3 4 5 . stop 80 0 1 6 .
    update-rc.d $OPT -f enable_autosleep.sh remove
    update-rc.d $OPT enable_autosleep.sh start 99 2 3 4 5 . stop 80 0 1 6 .
    update-rc.d $OPT -f time_services remove
    update-rc.d $OPT time_services start 01 2 3 4 5 . stop 80 0 1 6 .
}
