IMAGE_INSTALL_append += " system-core-adbd"
IMAGE_INSTALL_append += " system-core-usb"
IMAGE_INSTALL_append += " system-core-liblog"
IMAGE_INSTALL_append += " system-core-libcutils"
# fix yocto-1.6 build issues
IMAGE_INSTALL_append += " expect"
IMAGE_INSTALL_append += " open-posix-testsuite lmbench iperf e2fsprogs"
require 9615-cdp-qcom-image.inc
require 9615-cdp-sierra-image.inc
