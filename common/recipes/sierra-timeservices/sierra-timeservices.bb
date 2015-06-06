DESCRIPTION = "Sierra Wireless Initialization"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://../ntpd_time_service;startline=2;endline=2;md5=22dcb8c37cc7ca6b4aad807c89ffc0d5"

RDEPENDS_${PN} = "time-services"

SRC_URI = "file://time_services \
           file://ntpd_time_service \
           file://ntpd_start \
           file://ntpd_stop \
           file://time_service.conf \
          "

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -D -m 0755 ${WORKDIR}/time_services -D ${D}${sysconfdir}/init.d/time_services
    install -D -m 0755 ${WORKDIR}/ntpd_time_service -D ${D}${sysconfdir}/init.d/ntpd_time_service
    install -D -m 0755 ${WORKDIR}/ntpd_stop -D ${D}${sysconfdir}/network/if-down.d/ntpd_stop
    install -D -m 0755 ${WORKDIR}/ntpd_start -D ${D}${sysconfdir}/network/if-up.d/ntpd_start
    install -D -m 0644 ${WORKDIR}/time_service.conf -D ${D}${sysconfdir}/time_service.conf

    [ -n "${D}" ] && OPT="-r ${D}" || OPT="-s"
    update-rc.d $OPT -f time_services remove
    update-rc.d $OPT time_services start 05 S . stop 95 S .
}
