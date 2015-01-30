# Packages installed to the root file system

IMAGE_INSTALL += "acdbloader"
IMAGE_INSTALL += "acdbmapper"
IMAGE_INSTALL += "audcal"
IMAGE_INSTALL += "audcaltests"
IMAGE_INSTALL += "audioalsa"
IMAGE_INSTALL += "audio-ftm"
#IMAGE_INSTALL += "cne"
#IMAGE_INSTALL += "common"
IMAGE_INSTALL += "csd-server"
IMAGE_INSTALL += "data"
IMAGE_INSTALL += "diag"
IMAGE_INSTALL += "diag-reboot-app"
IMAGE_INSTALL += "mbim"
# SWISTART
# Disabling FOTA services
#IMAGE_INSTALL += "ipthdme"
# SWISTOP
IMAGE_INSTALL += "qmi"
IMAGE_INSTALL += "cxm-apps"
IMAGE_INSTALL += "qmi-framework"
# SWISTART
# Disabling qmi-shutdown-modem
#IMAGE_INSTALL += "qmi-shutdown-modem"
# SWISTOP
#IMAGE_INSTALL += "gps"
#IMAGE_INSTALL += "thermal"
IMAGE_INSTALL += "time-services"
# SWISTART
# Disabling FOTA services
#IMAGE_INSTALL += "wap-fota-daemon"
# SWISTOP
#IMAGE_INSTALL += "kernel-tests"
IMAGE_INSTALL += "modem-shutdown"
IMAGE_INSTALL += "loc-api"

#Check if the wlan-proprietary folder exists before including it in the image
#WLAN_DIR_PRESENT = ${@os.path.exists('${WORKSPACE}/wlan-proprietary')}
#IMAGE_INSTALL += "${@base_conditional('WLAN_DIR_PRESENT', 'True', 'wlan-proprietary', '', d)}"

