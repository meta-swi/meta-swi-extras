DESCRIPTION = "Sierra Wireless WP7 and AR7 module Initialization"
HOMEPAGE = "http://www.sierrawireless.com"
LICENSE = "SierraWireless-Proprietary"
LIC_FILES_CHKSUM = "file://../startm2m.sh;startline=2;endline=2;md5=22dcb8c37cc7ca6b4aad807c89ffc0d5"

DEPENDS = "sierra linux-yocto legato-init"

SRC_URI = " \
          file://startm2m.sh \
          file://usbsetup \
          file://usbmode \
          "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_compile() {
    :
}

do_generate_version_file() {
    DST="${WORKDIR}/version"

    # Firmware
    if echo ${BBLAYERS} |grep "meta-swi-bin"; then
        # meta-swi-bin: Use fw-version
        swi_bin_dir=$(echo "${BBLAYERS}" |tr ' ' '\n' |grep meta-swi-bin |uniq)
        VERSION_fw=$(cat $swi_bin_dir/fw-version)
    else
        # meta-swi-src
        if [ -d "${WORKSPACE}" ]; then
            cd ${WORKSPACE}

            # Try git first
            if git rev-parse HEAD; then
                git_rev=$(git describe --tags || true)
                if [ -n "$git_rev" ]; then
                    VERSION_fw="$git_rev (from '${WORKSPACE}')"
                else
                    git_rev=$(git rev-parse --short HEAD)
                    VERSION_fw="$git_rev (from '${WORKSPACE}')"
                fi
            elif [ -d ".svn" ]; then
                # Try svn
                svn_rev=$(svnversion)
                if [ $? -eq 0 ]; then
                    VERSION_fw="r$svn_rev (from '${WORKSPACE}')"
                fi
            fi
        fi

        if [ -z "$VERSION_fw" ]; then
            VERSION_fw="unknown (from '${WORKSPACE}')"
        fi
    fi

    # Poky
    poky_dir=$(echo ${BBLAYERS} |tr ' ' '\n' |grep poky|head -1)
    VERSION_poky=$(cd $poky_dir && git describe --tags)

    # meta-swi
    meta_swi_dir=$(echo ${BBLAYERS} |tr ' ' '\n' |grep -E "meta-swi$")
    if [ -d $meta_swi_dir/.git ]
    then
        VERSION_meta_swi=$(cd $meta_swi_dir && git describe --tags)
    else 
        VERSION_meta_swi="Customer build"
    fi

    # meta-swi-extras
    meta_swi_extras_dir=$(echo ${BBLAYERS} |tr ' ' '\n' |grep -E "meta-swi-extras" |head -1)
    if [ -d $meta_swi_extras_dir/.git ]
    then
        VERSION_meta_swi_extras=$(cd $meta_swi_extras_dir && git describe --tags)
    else
        VERSION_meta_swi_extras="Customer build"
    fi

    # linux-yocto
    # TODO: find a nicer way to do this
    kernel_versions=$(cat ${STAGING_KERNEL_DIR}/kernel-image-name | grep -Po '\+([\w]{6,})_([\w]{6,})' | sed 's/[+_]/ /g')
    kernel_meta_rev=$(echo $kernel_versions |awk '{print $1}')
    kernel_machine_rev=$(echo $kernel_versions |awk '{print $2}')
    cd ${LINUX_REPO_DIR}
    VERSION_kernel_meta="($(git branch --contains $kernel_meta_rev |sed 's/^[* ]*//g' | sed "N;s/\n/,/")) $kernel_meta_rev"
    VERSION_kernel_machine="($(git branch --contains $kernel_machine_rev |sed 's/^[* ]*//g' | sed "N;s/\n/,/")) $kernel_machine_rev"

    rm -f $DST
    echo -e "Build created at $(date)" >> $DST
    echo -e "" >> $DST
    echo -e "Yocto build version: ${VERSION_fw}" >> $DST
    echo -e "" >> $DST
    echo -e "Build host: $(hostname)" >> $DST
    echo -e "Versions:" >> $DST
    echo -e " - firmware: ${VERSION_fw}" >> $DST
    echo -e " - poky: ${VERSION_poky}" >> $DST
    echo -e " - meta-swi: ${VERSION_meta_swi}" >> $DST
    echo -e " - meta-swi-extras: ${VERSION_meta_swi_extras}" >> $DST
    echo -e " - linux-yocto-3.4/meta: ${VERSION_kernel_meta}" >> $DST
    echo -e " - linux-yocto-3.4/machine: ${VERSION_kernel_machine}" >> $DST

    cat $DST
}

addtask generate_version_file before do_install

do_generate_version_file[nostamp] = "1"
do_generate_version_file[doc] = "Generate a version file that describe the build environment"

do_install_append () {
    install -m 0755 ${WORKDIR}/startm2m.sh -D ${D}${sysconfdir}/init.d/startm2m.sh

    [ -n "${D}" ] && OPT="-r ${D}" || OPT="-s"
    update-rc.d $OPT -f startm2m.sh remove
    update-rc.d $OPT startm2m.sh start 99 5 . stop 01 S 0 1 2 3 4 6 .

    # Install the custom USB scripts
    install -m 0755 -d ${D}${sysconfdir}/legato
    install -m 0700 ${WORKDIR}/usbsetup ${D}${sysconfdir}/legato/usbsetup
    install -m 0644 ${WORKDIR}/version ${D}${sysconfdir}/legato/version

    if [ ${LEGATO_BUILD} = "true" ]
    then
        install -m 0600 ${WORKDIR}/usbmode ${D}${sysconfdir}/legato/usbmode.ex
    fi
}

FILES_${PN} = " \
          ${sysconfdir}/ \
              "

