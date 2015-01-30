# Packages installed to the root file system

IMAGE_INSTALL += "sierra"
IMAGE_INSTALL += "sierra-m2m-init"
IMAGE_INSTALL += "sierra-initscripts"
IMAGE_INSTALL += "time-services"
IMAGE_INSTALL += "legato-init"

# Add some extra packages for tool integration
IMAGE_INSTALL += "dropbear"
IMAGE_INSTALL += "strace"
IMAGE_INSTALL += "gdbserver"
IMAGE_INSTALL += "python-core"
IMAGE_INSTALL += "lttng-ust"
IMAGE_INSTALL += "lttng-modules"

IMAGE_INSTALL += "iproute2"
IMAGE_INSTALL += "iptables"

IMAGE_INSTALL += "opkg"
IMAGE_INSTALL += "openssl"
IMAGE_INSTALL += "ppp"

# Adds an alternative to tar (bsdtar)
IMAGE_INSTALL += "libarchive"
IMAGE_INSTALL += "libarchive-bin"

# Enable (de)compression with bz2
IMAGE_INSTALL += "bzip2"

#Required for extended file attributes
IMAGE_INSTALL += "attr"

#Adds EPOLLWAKEUP app to monitor USB link
IMAGE_INSTALL += "epollwakeup"

# Required for some Developer Studio features.
# Not needed for production builds
IMAGE_INSTALL += "openssh-sftp-server"
IMAGE_INSTALL += "tcf-agent"

do_copy_swi_version() {
    cd ${DEPLOY_DIR_IMAGE}
    cp ${IMAGE_ROOTFS}/etc/legato/version ${IMAGE_NAME}.rootfs.version
    ln -sf ${IMAGE_NAME}.rootfs.version ${IMAGE_LINK_NAME}.version
}

addtask copy_swi_version after do_rootfs before do_build

