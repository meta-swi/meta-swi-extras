inherit autotools

DESCRIPTION = "Qualcomm MSM Interface (QMI) Library"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"

PR = "r7"

DEPENDS = "configdb diag"

CFLAGS += "${CFLAGS_EXTRA}"
CFLAGS_EXTRA_append_arm = " -fforward-propagate"

EXTRA_OECONF = "--with-qxdm \
                --with-common-includes=${STAGING_INCDIR}"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://qmi"

S = "${WORKDIR}/qmi"

INITSCRIPT_NAME = "qmuxd"
INITSCRIPT_PARAMS = "start 40 S . stop 60 S ."

inherit proprietary-qcom

inherit update-rc.d

do_install_append() {
       install -m 0755 ${THISDIR}/files/qmuxd -D ${D}${sysconfdir}/init.d/qmuxd
       install -m 0755 ${THISDIR}/files/start_qmuxd -D ${D}${sysconfdir}/init.d/start_qmuxd
}
