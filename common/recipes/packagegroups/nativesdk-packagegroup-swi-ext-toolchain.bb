SUMMARY = "Sierra Software Development Kit (External Release)"
LICENSE = "MIT"
PR = "r1"

inherit packagegroup nativesdk

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS_${PN} += "\
    cwetool \
    "
