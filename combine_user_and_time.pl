#!/usr/bin/perl
#
# Get the CSV of start numbers and names
# Read a dump from the brower clock as a CSV
# Replace start numbers with name in a new
# CSV file
#
use LWP::Simple;

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
