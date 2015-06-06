
do_patch_qmi() {
    if [ -e "${S}/proprietary/qct/update.sh" ]; then
        cd ${S}/proprietary/qct
        ./update.sh "${WORKSPACE}/.."
    fi
}

addtask patch_qmi after do_patch before do_build

