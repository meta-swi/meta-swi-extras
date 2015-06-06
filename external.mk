
KBRANCH_mdm9x15 := standard/swi-mdm9x15-yocto-1.6-swi
KMETA := meta-yocto-1.6-swi

KBRANCH_mdm9x15_REV := $(shell cd kernel && git rev-parse HEAD | cut -c 1-10 -)

KBRANCH_mdm9x15_CURRENT_REV := $(shell cd kernel && git show-ref -s refs/heads/${KBRANCH_mdm9x15} | cut -c 1-10 -)
KMETA_CURRENT_REV := $(shell cd kernel && git show-ref -s refs/heads/${KMETA} | cut -c 1-10 -)

# Set number of threads
NUM_THREADS ?= 9

# Set Legato repo location (use one option)
# You could also use github or a download location
# Github is the default if you unset this value
# See meta-swi/common/recipes-legato/legato-af for where this is set

# This assumes you have used repo and you have legato synced
#LEGATO_REPO := "git://$(PWD)/legato/.git\;protocol\=file\;rev\=${LEGATO_REV}\;nobranch\=1"
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
				-x "kernel" \
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

## extras needed for building

poky:
	git clone git://git.yoctoproject.org/poky
	cd poky && git checkout refs/tags/daisy-11.0.2

meta-openembedded:
	git clone git://git.openembedded.org/meta-openembedded
	cd meta-openembedded && git checkout 8e6f6e49c99a12a0382e48451f37adac0181362f

## images

image_bin: poky meta-openembedded
	$(COMMON_BIN)

image: image_bin

## toolchains

toolchain_bin: poky meta-openembedded
	$(COMMON_BIN) -k

toolchain: toolchain_bin

## dev shell

dev: poky meta-openembedded
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

image_virt_arm:
	$(COMMON_VIRT_ARM) -d

image_virt_x86:
	$(COMMON_VIRT_X86) -d

image_virt: image_virt_arm

## toolchains

toolchain_virt_arm:
	$(COMMON_VIRT_ARM) -k

toolchain_virt_x86:
	$(COMMON_VIRT_X86) -k

toolchain_virt: toolchain_virt_arm

## dev shell

dev_virt_arm: 
	$(COMMON_VIRT_ARM) -c

dev_virt_x86:
	$(COMMON_VIRT_X86) -c

dev_virt: dev_virt_arm

