inherit autotools

DESCRIPTION = "Sierra Wireless Library"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/sierra/aa/aaglobal.h;startline=18;endline=19;md5=b0ac0718cbf86eee361263b7942315bb"

PN = "sierra"
PR = "r0"

DEPENDS = "configdb audcal acdbloader acdbmapper"
DEPENDS += "qmi-framework"
DEPENDS += "data"
DEPENDS += "alsa-intf"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = " \
            file://sierra \
            file://external/hostap \
            "

S = "${WORKDIR}/sierra"

USERRW_MOUNTPOINT = "/mnt/userrw"
PERSIST_MOUNTPOINT = "/mnt/persist"
# Flash mountpoint is for the large flash partition
FLASH_MOUNTPOINT = "/mnt/flash"
# Extra flash mount point for misc flash use (e.g. mounting user0 partition).
FLASH_MOUNTPOINT_LEGATO = "/mnt/legato"
# Required by some
DATA_DIR = "/data"
# Legato currently installs in opt with libs in /usr/local
LEGATO_MOUNTPOINT = "/opt"
LEGATO_LIBS = "/usr/local"

EXTRA_OECONF = "--with-lib-path=${STAGING_LIBDIR} \
                --with-common-includes=${STAGING_INCDIR} \
                --with-sanitized-headers=${STAGING_KERNEL_DIR}/include \
                --with-glib \
                --with-qxdm \
                WORKSPACE=${WORKSPACE} \
               "

EXTRA_OEMAKE = " WORKSPACE=${WORKSPACE} "

# Tell bitbake that we built another packages as well
# .. and assign files to these packages
PACKAGES =+ "${PN}-webserver"
FILES_${PN}-webserver = "${bindir}/SierraWebApp \
                         ${bindir}/../web \
                         "

# Assign dbi files to a separate package
#PACKAGES =+ "${PN}-dbi"
#FILES_${PN}-dbi = "${bindir}/dbi"

inherit proprietary-qcom

do_patch() {
    # Prevent USB audio
    sed -i 's/BCBOOTAPPFLAG_AUDIO_ENABLE_M/0/g' ${WORKDIR}/sierra/ud/uduser.c
}

# Install all additional files/dirs
do_install_append() {
    # create USERRW mount point
    install -m 0755 -d ${D}${USERRW_MOUNTPOINT}
    install -m 0755 -d ${D}${PERSIST_MOUNTPOINT}
    install -m 0755 -d ${D}${FLASH_MOUNTPOINT}
    install -m 0755 -d ${D}${FLASH_MOUNTPOINT_LEGATO}
    install -m 0755 -d ${D}${DATA_DIR}
    install -m 0755 -d ${D}${LEGATO_MOUNTPOINT}
    install -m 0755 -d ${D}${LEGATO_LIBS}

    # add audio files to rootfs
    install -m 0755 ${WORKDIR}/sierra/av/audio_player.sh -D ${D}/usr/sbin/audio_player.sh
    #install -m 0666 ${WORKDIR}/sierra/av/audio_cal.acdb -D ${D}${sysconfdir}/audio_cal.acdb
    install -m 0666 ${WORKDIR}/sierra/av/ring.wav -D ${D}/data/ring.wav
}

# Add files/dirs that need to be put into sierra package
FILES_${PN} += " \
               ${USERRW_MOUNTPOINT} \
               ${PERSIST_MOUNTPOINT} \
               ${FLASH_MOUNTPOINT} \
               ${FLASH_MOUNTPOINT_LEGATO} \
               ${DATA_DIR}/* \
               ${LEGATO_MOUNTPOINT} \
               ${LEGATO_LIBS} \
               "
