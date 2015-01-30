DESCRIPTION = "Sierra Wireless Library"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=dbdf22205bb8b7f613788e897d3e869e"

PN = "sierra"
PR = "r0"

DEPENDS = "configdb"
DEPENDS += "qmi-framework"
DEPENDS += "data"

SRC_URI = " \
            file://sierra-bin.tar.bz2 \
            file://audio_player.sh \
            file://ring.wav \
            file://LICENSE \
            "

S = "${WORKDIR}/sierra-bin"

USERRW_MOUNTPOINT = "/mnt/userrw"
PERSIST_MOUNTPOINT = "/mnt/persist"
# Flash mountpoint is for the large flash partition
FLASH_MOUNTPOINT = "/mnt/flash"

# Tell bitbake that we built another packages as well
# .. and assign files to these packages
PACKAGES =+ "${PN}-webserver"
FILES_${PN}-webserver = "${bindir}/SierraWebApp \
                         ${bindir}/../web \
                         "


# Install all additional files/dirs
do_install_append() {
    # create USERRW mount point
    install -m 0755 -d ${D}${USERRW_MOUNTPOINT}
    install -m 0755 -d ${D}${PERSIST_MOUNTPOINT}
    install -m 0755 -d ${D}${FLASH_MOUNTPOINT}
    cp -R --preserve=links ${S}/usr ${D}

    # add audio files to rootfs
    install -m 0755 ${WORKDIR}/audio_player.sh -D ${D}/usr/sbin/audio_player.sh
    install -m 0666 ${WORKDIR}/ring.wav -D ${D}/data/ring.wav
}

# Add files/dirs that need to be put into sierra package
FILES_${PN} += " \
               ${USERRW_MOUNTPOINT} \
               ${PERSIST_MOUNTPOINT} \
               ${FLASH_MOUNTPOINT} \
               /data/ring.wav \
               /usr/sbin/audio_player.sh \
               "
