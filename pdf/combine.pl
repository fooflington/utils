#!/usr/bin/perl -w

use strict;

use PDF::API2;

my ($odds, $evens, $out) = @ARGV or die "$0: odds.pdf evens.pdf outfile.pdf";

die "$out already exists" if -f $out;

my $odds_pdf = PDF::API2->open($odds) or die "Unable to open $odds: $!";
my $evens_pdf = PDF::API2->open($evens) or die "Unable to open $evens: $!";

die "Page count mismatch ($odds=" . $odds_pdf->pages() . " <> $evens=" . $evens_pdf->pages() . ")"
	unless $odds_pdf->pages == $evens_pdf->pages();

my $new_pdf = PDF::API2->new();
my $numpages = $odds_pdf->pages();

print "Pages: $numpages\n";
my $curpage = 1;
for(my $i=0; $i < $numpages; $i++) {
	print "[odd] Adding $odds:", $i+1, " as ", $curpage, "\n";
	$new_pdf->importpage($odds_pdf,  $i + 1        , $curpage++);
	print "[evn] Adding $evens:", $numpages-$i, " as ", $curpage, "\n";
	$new_pdf->importpage($evens_pdf, $numpages - $i, $curpage++);
}

print "Saving...\n";
$new_pdf->saveas($out);
