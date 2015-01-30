DESCRIPTION = "GPS Location API"
PR = "r3"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=3775480a712fc46a69647678acb234cb"

SRC_URI = "file://loc-api-bin.tar.bz2"
DEPENDS = "qmi-framework glib-2.0 libhardware"

S = "${WORKDIR}/loc-api-bin"

do_install_append(){
    cp -R --preserve=links ${S}/usr ${D}
}


