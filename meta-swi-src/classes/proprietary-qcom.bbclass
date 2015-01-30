# BB Class to handle proprietary sources from Qualcomm

PACKAGES =+ "${PN}-qcomdev"
FILES_${PN}-qcomdev = "${includedir}/${PN}/*.h"

PACKAGES =+ "${PN}-qcomdbg"
FILES_${PN}-qcomdbg = "${FILES_${PN}-dbg}"

QAPATHTEST[debug-files] = ""
