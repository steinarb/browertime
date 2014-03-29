#!/usr/bin/perl
#
# Get the CSV of start numbers and names
# Read a dump from the brower clock as a CSV
# Replace start numbers with name in a new
# CSV file
#
use LWP::Simple;
use POSIX qw{strftime};

#
# Read the name map CSV, and store the mapping in an
# associative array in perl.
$startNumberToNameMapCsv = "https://docs.google.com/spreadsheet/pub?key=0AtQuQf-v5j4JdF90elI3SlhjQ0c3Tm1wNTNSLXduN2c&output=csv";
@startNumberToNameMapLines = split(/\n/, get($startNumberToNameMapCsv));
foreach my $line (@startNumberToNameMapLines) {
    my ($startnummer,$fornavn,$etternavn) = split(/,/, $line);
    if ($startnummer != "startnummer" && $fornavn) {
        $numberToNameMap{$startnummer} = $fornavn;
    }
}



# Read fixed width file containing timings into memory.
$inputFileName=$ARGV[0];

open(INPUTFILE, "<", $inputFileName);
# First skip the header lines
for ($i=0; $i<8; ++$i) {
    $line = <INPUTFILE>;
}

# Read the fixed width lines containing timing information
$format="A8 A14 A15 A15 A15 A15 A15 A";
while(<INPUTFILE>) {
    $line = $_;
    $line =~ s/,/./g; # Replace Norwegian locale decimal commas with US decimal points
    my($seq, $bib, $time, $start, $finish, $split1, $split2, $split3) = unpack($format, $line);
    my $fractionOfSeconds = $time;
    $fractionOfSeconds =~ s/^.*\.//; # Keep just the numbers after the decimal point
    my $timeAsMinutesAndSeconds = strftime("\%M:\%S", gmtime($time));
    $timeAsMinutesAndSecondsAndFraction = $timeAsMinutesAndSeconds.".".$fractionOfSeconds;
    $existingValue = $times{$bib};
    if ($existingValue) {
        $valueWithTimeAppended = join(",", $existingValue, $timeAsMinutesAndSecondsAndFraction);
    } else {
        $valueWithTimeAppended = $timeAsMinutesAndSecondsAndFraction;
    }
    $times{$bib} = $valueWithTimeAppended;
}

close(INPUTFILE);

$outputFileName=$inputFileName;
$outputFileName =~ s/.txt$/.csv/;
open(OUTPUTFILE, ">", $outputFileName);


foreach $bib (keys %times) {
    $name = $numberToNameMap{$bib};
    if (!$name) {
        $name = $bib;
    }
    $times = $times{$bib};
    print(OUTPUTFILE "$name,$times\n");
}


close(OUTPUTFILE);
