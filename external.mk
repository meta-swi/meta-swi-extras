
KBRANCH := standard/swi-mdm9x15-yocto-1.6-swi
KMETA := meta-yocto-1.6-swi

# Set number of threads
NUM_THREADS ?= 4

# Set workspace directory
APPS_DIR ?= mdm9x15/apps_proc/

all: image_bin

clean:
	rm -rf build_*

ifeq ($(USE_ICECC),1)
	ICECC_ARGS := -h
endif

# Replaces this Makefile by a symlink to repo.mk
$(shell if ! test -h Makefile; then rm -f Makefile && ln -s meta-swi-extras/repo.mk Makefile; fi)

COMMON_ARGS := \
				-p poky/ \
				-o meta-openembedded/ \
				-l meta-swi \
				-x "linux-yocto-3.4.git" \
				-j $(NUM_THREADS) \
				-t $(NUM_THREADS) \
				$(ICECC_ARGS)

poky:
	git clone git://git.yoctoproject.org/poky
	cd poky && git checkout bda51ee7821de9120f6f536fcabe592f2a0c8a37

meta-openembedded:
	git clone git://git.openembedded.org/meta-openembedded
	cd meta-openembedded && git checkout 8e6f6e49c99a12a0382e48451f37adac0181362f

image_bin: poky meta-openembedded
		meta-swi-extras/build.sh $(COMMON_ARGS) \
			-m swi-mdm9x15 \
			-b build_bin \
			-q \
			-g 

image_virt: poky meta-openembedded
		meta-swi-extras/build.sh $(COMMON_ARGS) \
			-m swi-virt \
			-b build_virt \
			-d

toolchain_bin: poky meta-openembedded
		meta-swi-extras/build.sh $(COMMON_ARGS) \
			-m swi-mdm9x15 \
			-b build_bin \
			-q \
			-k \
			-g 

dev: poky meta-openembedded
		meta-swi-extras/build.sh $(COMMON_ARGS) \
			-m swi-mdm9x15 \
			-b build_bin \
			-c

