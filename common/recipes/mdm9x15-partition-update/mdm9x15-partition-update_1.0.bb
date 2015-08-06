DESCRIPTION = "Sierra Wireless Library"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=dbdf22205bb8b7f613788e897d3e869e"

DEPENDS = "cwetool"
DEPENDS += "mdm9x15-image-minimal"

SRC_URI += "file://LICENSE"
SRC_URI += "file://custom_partition.xml"

INC_PR = "r0"

# Path to FIRMWARE tarball ar_yocto-cwe.tar.bz2
#FIRMWARE_PATH ?= "/any places on your filesystem/"

S = "${WORKDIR}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_fetch_firmware() {

	if test -z "${FIRMWARE_PATH}"; then
		echo "You need to set the location of the firmware tarball into the variable FIRMWARE_PATH"
		exit 1
	fi

	if ! test -e ${FIRMWARE_PATH}/ar_yocto-cwe.tar.bz2; then
		echo "Archive ${FIRMWARE_PATH}/ar_yocto-cwe.tar.bz2 is missing"
		exit 1
	fi

	echo "Extrating files from firmware..."
	tar -C ${S} -jxpf ${FIRMWARE_PATH}/ar_yocto-cwe.tar.bz2 \
		ar_yocto-cwe/modemz.cwe \
		ar_yocto-cwe/boot_partition_update.cwe
}
addtask fetch_firmware after do_fetch before do_patch

do_install() {
	install -m 0644 ${S}/ar_yocto-cwe/modemz.cwe ${DEPLOY_DIR_IMAGE}/
	install -m 0644 ${S}/ar_yocto-cwe/boot_partition_update.cwe ${DEPLOY_DIR_IMAGE}/
	install -m 0644 ${S}/custom_partition.xml ${DEPLOY_DIR_IMAGE}/
}

do_generate_update_cwe[depends] = "mdm9x15-image-minimal:do_build"

do_generate_update_cwe() {
	cd ${DEPLOY_DIR_IMAGE}/

	for target in `ls boot-yocto-legato*.cwe 2>/dev/null | sed 's/boot-yocto-legato_//;s/\.cwe//'`
	do
		case $target in
			ar7|ar86)
				splitboot boot_partition_update.cwe
				yocto_partition_update_cwe.sh $target
				;;
			*)
				echo "Target $target is currently not supported"
				;;
		esac
	done
}

addtask generate_update_cwe after do_install before do_build
