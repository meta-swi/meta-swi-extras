DESCRIPTION = "USB Mobile Broadband Interface Model (MBIM) Command Processor"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://${WORKSPACE}/oe-core/meta-qcom/files/qcom-licenses/\
QUALCOMM-Proprietary;md5=92b1d0ceea78229551577d4284669bb8"

DEPENDS = "diag qmi qmi-framework"

# SWISTART 
DEPENDS += "sierra"
# SWISTOP

# Package Revision (update whenever recipe is changed)
PR = "r0"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/:"

SRC_URI = "file://mbim"

S = "${WORKDIR}/mbim"

inherit autotools pkgconfig

EXTRA_OECONF = "--with-common-includes=${STAGING_INCDIR}"

EXTRA_OEMAKE = " INCLUDES='-I${S}/{qmi_svc/api,wmsts/api} -I${srcdir}/{inc,api,svc/inc} -I${srcdir}/platform/{inc,api} -I${srcdir}/framework/inc' "

INITSCRIPT_NAME = "mbim"
INITSCRIPT_PARAMS = "start 96 S . stop 4 S ."

inherit update-rc.d

do_install_append() {
  install -m 0755 ${WORKDIR}/mbim/start_mbimd -D ${D}${sysconfdir}/init.d/mbim
}

inherit proprietary-qcom

