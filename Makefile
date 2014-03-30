#
# GNU make Makefile for converting fixed width files
# exported from the Brower clock into CSV files
# with skier names taking from a google docs 
# spreadsheet that maps from bibs (start numbers)
# to names.
#
# The CSV files are also rebuilt when the script
# or the Makefile itself changes.
#
#
CONVERT_TXT_TO_CSV_SCRIPT=combine_user_and_time.pl
%.csv : %.txt
	perl $(CONVERT_TXT_TO_CSV_SCRIPT) "$<"

TXTFILES:=$(wildcard *.txt)
TARGETS:=$(TXTFILES:.txt=.csv)

all: $(TARGETS)

$(TARGETS): $(CONVERT_TXT_TO_CSV_SCRIPT) Makefile 

clean:
	rm -f "$(TARGETS)"
