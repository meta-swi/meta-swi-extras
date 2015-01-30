SUMMARY = "Sierra Software Development Kit (Internal Release)"
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
    libgcov-dev \
    sierra-dev-headers-dev \
    "
