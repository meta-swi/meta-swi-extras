inherit autotools

DESCRIPTION = "Time Services Daemon"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"
PR = "r2"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://time-services"

DEPENDS = "qmi-framework"
RDEPENDS_${PN} = "qmi-framework"

S = "${WORKDIR}/time-services"

# override default install if starting time_serived by time_services. Remove the following
# to have time_serviced itself be started at boot.
do_install () {
    install -D -m 0755 ${WORKDIR}/time-services/time_serviced -D ${D}${sysconfdir}/init.d/time_serviced
    install -D -m 0755 ${WORKDIR}/time-services/time_daemon -D ${D}${bindir}/time_daemon
}

# uncomment the following if not using sierra time_services
#do_install_append(){
#    chmod 0755 ${D}${sysconfdir}/init.d/time_serviced
#}

inherit proprietary-qcom

