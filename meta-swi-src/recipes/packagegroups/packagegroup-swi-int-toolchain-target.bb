SUMMARY = "Sierra Software Development Kit (Internal Release)"
LICENSE = "MIT"
PR = "r1"

require common/recipes/packagegroups/packagegroup-swi-ext-toolchain-target.bb

RDEPENDS_${PN} += "\
    qmi-qcomdev \
    qmi-framework-qcomdev \
    loc-api-qcomdev \
    sierra-qcomdev \
    "
