DESCRIPTION = "USB Mobile Broadband Interface Model (MBIM) Command Processor"
HOMEPAGE = "http://support.cdmatech.com"
LICENSE = "QUALCOMM-Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f14a1e7bf970664cfc207ce3ebf89af"

DEPENDS = "diag qmi qmi-framework"

# SWISTART 
DEPENDS += "sierra"
# SWISTOP

# Package Revision (update whenever recipe is changed)
PR = "r0"

SRC_URI = "file://mbim-bin.tar.bz2"

S = "${WORKDIR}/mbim-bin"

INITSCRIPT_NAME = "mbim"
INITSCRIPT_PARAMS = "start 96 S . stop 4 S ."

inherit update-rc.d

do_install_append() {
  cp -R --preserve=links ${S}/usr ${D}
  cp -R --preserve=links ${S}/etc ${D}
}

