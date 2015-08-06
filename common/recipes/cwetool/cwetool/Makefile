#
# Copyright (C) Sierra Wireless Inc. All rights reserved.
#

CXX ?= g++

all: fotapkghdrcat cwezip hdrcnv splitboot

clean:
	rm cwezip fotapkghdrcat hdrcnv splitboot

cwezip: cwezip.cpp
	$(CXX) -o $@ $< -lz

fotapkghdrcat: fotapkghdrcat.cpp
	$(CXX) -o $@ $<

hdrcnv: hdrcnv.cpp
	$(CXX) -o $@ $<

splitboot: splitboot.c
	$(CC) -o $@ $<
