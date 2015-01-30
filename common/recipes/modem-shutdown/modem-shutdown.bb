DESCRIPTION = "Automatically shuts the modem down on halt and reboot"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://modem-shutdown.sh;startline=3;endline=4;md5=ab9c1b9fae52aed0f9b0e44f2ac4b786"
PR="r1"

SRC_URI = "file://modem-shutdown.sh"

S = "${WORKDIR}"

#does not appear to work if run as start 01
INITSCRIPT_NAME = "modem-shutdown"
INITSCRIPT_PARAMS = "stop 01 S ."

inherit update-rc.d

do_install() {
        install -m 0755 ${S}/modem-shutdown.sh -D ${D}/${sysconfdir}/init.d/modem-shutdown
        mkdir -p ${D}/bin
        ln -s /etc/init.d/modem-shutdown ${D}/bin/modem-shutdown 
}
