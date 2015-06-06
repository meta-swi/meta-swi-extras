SUMMARY = "Sierra Software Development Kit (Internal Release)"
LICENSE = "MIT"
PR = "r1"

require common/recipes/packagegroups/nativesdk-packagegroup-swi-ext-toolchain.bb

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS_${PN} += "\
    "
