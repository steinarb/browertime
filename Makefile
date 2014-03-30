#
# GNU make Makefile for creating PostScript files from SGML files
#
# $Id$
#
CONVERT_TXT_TO_CSV_SCRIPT=combine_user_and_time.pl
%.csv : %.txt
	perl $(CONVERT_TXT_TO_CSV_SCRIPT) "$<"

TXTFILES:=$(wildcard *.txt)
TARGETS:=$(TXTFILES:.txt=.csv)

all: $(TARGETS)

$(TARGETS): $(CONVERT_TXT_TO_CSV_SCRIPT) Makefile 

clean:
	rm -f $(TARGETS)
