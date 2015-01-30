
KBRANCH_mdm9x15 := standard/swi-mdm9x15-yocto-1.6-swi
KMETA := meta-yocto-1.6-swi

KBRANCH_mdm9x15_REV := $(shell cd kernel && git rev-parse HEAD | cut -c 1-10 -)
KMETA_REV := $(shell cd kernel-meta && git rev-parse HEAD | cut -c 1-10 -)
LEGATO_REV := $(shell cd legato && git rev-parse HEAD)

KBRANCH_mdm9x15_CURRENT_REV := $(shell cd kernel && git show-ref -s refs/heads/${KBRANCH_mdm9x15} | cut -c 1-10 -)
KMETA_CURRENT_REV := $(shell cd kernel && git show-ref -s refs/heads/${KMETA} | cut -c 1-10 -)

# Set number of threads
NUM_THREADS ?= 9

# Set workspace directory
APPS_DIR ?= mdm9x15/apps_proc/

# Set Legato repo location (use one option)
# You could also use github or a download location
# Github is the default is you unset this value
# See meta-swi/common/recipes-legato/legato-af for where this is set

# This assumes you have used repo and you have legato synced
LEGATO_REPO := "git://$(PWD)/legato/.git\;protocol\=file\;rev\=${LEGATO_REV}\;nobranch\=1"
# Example using AUTOREV to grab the latest
#LEGATO_REPO := "git://$(PWD)/legato/.git\;protocol\=file\;rev\=\$${AUTOREV}"
# Example using cgit to fetch from the server (set to 15.01.rc1)
#LEGATO_REPO := "git://cgit-legato/Legato.git/\;protocol\=http\;rev\=89d4a7c4c53581095103ea2b1212ae35a9b5f6e5"

# Use docker abstraction ?
USE_DOCKER ?= 0

# Use distributed building ?
USE_ICECC ?= 0

all: image_bin

clean:
	rm -rf build_*

ifeq ($(USE_ICECC),1)
    ICECC_ARGS = -h
endif

ifdef FW_VERSION
    FW_VERSION_ARG := -v $(FW_VERSION)
endif

ifdef LEGATO_REPO
    LEGATO_ARGS := -a "LEGATO_REPO=${LEGATO_REPO}"
endif

# Replaces this Makefile by a symlink to repo.mk
$(shell if ! test -h Makefile; then rm -f Makefile && ln -s meta-swi-extras/repo.mk Makefile; fi)

# Create branches KBRANCH / KMETA in kernel
.PHONY: kernel_branches
kernel_branches:
	@echo "kernel KBRANCH_mdm9x15 (${KBRANCH_mdm9x15}): ${shell cd kernel && git log -1 --pretty=oneline ${KBRANCH_mdm9x15_REV}}"
	@if ! ( cd kernel && git branch |grep ${KBRANCH_mdm9x15} > /dev/null ); then \
		echo "Create dev kernel branch ${KBRANCH_mdm9x15}" ; \
		cd kernel && git branch ${KBRANCH_mdm9x15} ${KBRANCH_mdm9x15_REV} ; \
	fi
	@bash -c '\
		if [[ "${KBRANCH_mdm9x15_CURRENT_REV}" != "${KBRANCH_mdm9x15_REV}" ]]; then \
			echo "=> Updating dev kernel meta branch ${KBRANCH_mdm9x15}: ${KBRANCH_mdm9x15_REV}" ; \
			cd kernel && git branch -f ${KBRANCH_mdm9x15} ${KBRANCH_mdm9x15_REV} ; \
		fi'
	@echo "kernel KMETA (${KMETA}): ${shell cd kernel && git log -1 --pretty=oneline ${KMETA_REV}}"
	@if ! ( cd kernel && git branch |grep ${KMETA} > /dev/null ); then \
		echo "Create dev kernel meta branch ${KMETA}: ${KMETA_REV}" ; \
		cd kernel && git branch ${KMETA} ${KMETA_REV} ; \
	fi
	@bash -c '\
		if [[ "${KMETA_CURRENT_REV}" != "${KMETA_REV}" ]]; then \
			echo "=> Updating dev kernel meta branch ${KMETA}: ${KMETA_REV}" ; \
			cd kernel && git branch -f ${KMETA} ${KMETA_REV} ; \
		fi'
	
	@if ! ( cd kernel && git branch |grep master > /dev/null ); then \
		echo "Create local master branch" ; \
		cd kernel && git branch master gerrit/master ; \
	fi

BUILD_SCRIPT := "meta-swi-extras/build.sh" 

# Provide a docker abstraction for Yocto building, allowing the host seen
# by the Yocto environment to be the ideal Linux distribution
ifeq ($(USE_DOCKER),1)
  UID := $(shell id -u)
  HOSTNAME := $(shell hostname)
  DOCKER_BIN ?= docker
  DOCKER_IMG := "corfr/yocto-dev"
  DOCKER_RUN := ${DOCKER_BIN} run \
                    --rm \
                    --user=${UID} \
                    --tty --interactive \
                    --hostname=${HOSTNAME} \
                    --volume ${PWD}:${PWD} \
                    --volume /etc/passwd:/etc/passwd \
                    --volume /etc/group:/etc/group \
                    --workdir ${PWD}
  BUILD_SCRIPT := ${DOCKER_RUN} ${DOCKER_IMG} ${BUILD_SCRIPT}
endif

COMMON_ARGS := ${BUILD_SCRIPT} \
				-p poky/ \
				-o meta-openembedded/ \
				-l meta-swi \
				-x "kernel/.git" \
				-j $(NUM_THREADS) \
				-t $(NUM_THREADS) \
				${ICECC_ARGS} \
				${LEGATO_ARGS}

# Machine: swi-mdm9x15

COMMON_BIN := \
				$(COMMON_ARGS) \
				-m swi-mdm9x15 \
				-b build_bin \
				-q \
				-g 

COMMON_SRC := \
				$(COMMON_ARGS) \
				-m swi-mdm9x15 \
				-b build_src \
				-w $(APPS_DIR) \
				$(FW_VERSION_ARG) \
				-q -s \
				-g

# Machine: swi-mdm9x15

## images

image_bin: kernel_branches
	$(COMMON_BIN)

image_src: kernel_branches
	$(COMMON_SRC)

## toolchains

toolchain_bin: kernel_branches
	$(COMMON_BIN) -k

toolchain_src: kernel_branches
	$(COMMON_SRC) -k

## dev shell

dev: kernel_branches
	$(COMMON_BIN) -c

dev_src: kernel_branches
	$(COMMON_SRC) -c

## kernel kitchen

KERNEL_DIR_TMP := tmp/work/swi_mdm9x15-poky-linux-gnueabi/linux-yocto/3.4.91+gitAUTOINC+${KMETA_REV}_${KBRANCH_mdm9x15_REV}-r4.5.1
KERNEL_DIR_BIN := build_bin/${KERNEL_DIR_TMP}
KERNEL_DIR_SRC := build_src/${KERNEL_DIR_TMP}

KERNEL_REMOTE := $(shell cd kernel && git remote -v | head -1 | awk '{print $$2}')

kernel_prepare: kernel_branches
	@echo "### kernel kitchen: Initial build ..."
	@echo "bitbake linux-yocto; exit" | \
		$(COMMON_BIN) -c
	
	@echo "### kernel kitchen: Preparing helpers in build_kernel/"
	@mkdir -p build_kernel
	@cd build_kernel && \
		rm -f src     && ln -s ../kernel src && \
		rm -f workdir && ln -s ../${KERNEL_DIR_BIN} workdir && \
		rm -f bld     && ln -s ../${KERNEL_DIR_BIN}/linux-swi_mdm9x15-standard-build bld && \
		rm -f config  && ln -s ../${KERNEL_DIR_BIN}/linux-swi_mdm9x15-standard-build/.config config && \
		rm -f boot-yocto-mdm9x15.img && ln -s ../build_bin/tmp/deploy/images/swi-mdm9x15/boot-yocto-mdm9x15.img boot-yocto-mdm9x15.img
	
	@echo "### kernel kitchen: Updating source directory within building directory to use the 'kernel' directory"
	@mv ${KERNEL_DIR_BIN}/linux ${KERNEL_DIR_BIN}/linux.orig
	@ln -s ${shell pwd}/kernel ${KERNEL_DIR_BIN}/linux

kernel_menuconfig:
	@echo "### kernel kitchen: menuconfig"
	@cd build_kernel/bld && ARCH=arm make menuconfig

kernel_build:
	@echo "### kernel kitchen: build"
	@echo "bitbake -c compile -f -v linux-yocto && bitbake -c bootimg -v linux-yocto; exit" | \
		$(COMMON_BIN) -c

# Machine: swi-virt

COMMON_VIRT_ARM := \
				$(COMMON_ARGS) \
				-m swi-virt-arm \
				-b build_virt-arm

COMMON_VIRT_X86 := \
				$(COMMON_ARGS) \
				-m swi-virt-x86 \
				-b build_virt-x86

## images

image_virt_arm: kernel_branches
	$(COMMON_VIRT_ARM) -d

image_virt_x86:
	$(COMMON_VIRT_X86) -d

image_virt: image_virt_arm

## toolchains

toolchain_virt_arm: kernel_branches
	$(COMMON_VIRT_ARM) -k

toolchain_virt_x86:
	$(COMMON_VIRT_X86) -k

toolchain_virt: toolchain_virt_arm

## dev shell

dev_virt_arm: kernel_branches
	$(COMMON_VIRT_ARM) -c

dev_virt_x86:
	$(COMMON_VIRT_X86) -c

dev_virt: dev_virt_arm

