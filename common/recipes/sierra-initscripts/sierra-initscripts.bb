DESCRIPTION = "Sierra Wireless Initialization"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://../swiapplaunch.sh;startline=2;endline=2;md5=22dcb8c37cc7ca6b4aad807c89ffc0d5"

SRC_URI = "file://confighw.sh \
           file://swiapplaunch.sh \
           file://varrw.sh \
           file://restart_swi_apps \
           file://start_dbi_daemon \
           file://restartNMEA \
           file://run.env \
           file://run_getty.sh \
           file://enable_autosleep.sh \
           file://mount_unionfs \
           file://mount_early \
          "

do_configure[noexec] = "1"
do_compile[noexec] = "1"

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
    install -D -m 0755 ${WORKDIR}/mount_unionfs -D ${D}${sysconfdir}/init.d/mount_unionfs
    install -D -m 0755 ${WORKDIR}/mount_early -D ${D}${sysconfdir}/init.d/mount_early

    [ -n "${D}" ] && OPT="-r ${D}" || OPT="-s"
    update-rc.d $OPT -f mount_early remove
    update-rc.d $OPT mount_early start 02 S . stop 98 S .
    update-rc.d $OPT -f confighw.sh remove
    update-rc.d $OPT confighw.sh start 03 S .
    update-rc.d $OPT -f mount_unionfs remove
    update-rc.d $OPT mount_unionfs start 04 S . stop 96 S .
    update-rc.d $OPT -f swiapplaunch.sh remove
    update-rc.d $OPT swiapplaunch.sh start 80 S . stop 20 S .
    update-rc.d $OPT -f varrw.sh remove
    update-rc.d $OPT varrw.sh start 36 S . stop 64 S .
    update-rc.d $OPT -f start_dbi_daemon remove
    update-rc.d $OPT start_dbi_daemon start 82 S . stop 18 S .
    update-rc.d $OPT -f enable_autosleep.sh remove
    update-rc.d $OPT enable_autosleep.sh start 99 S . stop 01 S .
}
