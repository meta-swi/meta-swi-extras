# Sierra toolchain
SIERRA_VARIANT ?= "ext"

require recipes-core/meta/meta-toolchain-swi.bb

TOOLCHAIN_HOST_TASK += "nativesdk-packagegroup-swi-${SIERRA_VARIANT}-toolchain"
TOOLCHAIN_TARGET_TASK += "packagegroup-swi-${SIERRA_VARIANT}-toolchain-target"
TOOLCHAIN_OUTPUTNAME = "${SDK_NAME}-toolchain-swi-${SIERRA_VARIANT}-${DISTRO_VERSION}"
