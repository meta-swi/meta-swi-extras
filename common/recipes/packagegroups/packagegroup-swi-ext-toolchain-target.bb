SUMMARY = "Sierra Software Development Kit (External Release)"
LICENSE = "MIT"
PR = "r1"

inherit packagegroup

RDEPENDS_${PN} += "\
    alsa-intf-dev \
    qmi-dev \
    qmi-framework-dev \
    loc-api-dev \
    sierra-dev \
    sierra-staticdev \
    sierra-dev-headers-dev \
    "
