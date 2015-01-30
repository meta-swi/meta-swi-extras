#
# Copyright (C) Sierra Wireless Inc. All rights reserved.
#

CXX ?= g++

all: fotapkghdrcat cwezip hdrcnv

clean:
	rm cwezip fotapkghdrcat hdrcnv

cwezip: cwezip.cpp
	$(CXX) -o $@ $< -lz

fotapkghdrcat: fotapkghdrcat.cpp
	$(CXX) -o $@ $<

hdrcnv: hdrcnv.cpp
	$(CXX) -o $@ $<

