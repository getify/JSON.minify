#/usr/bin/perl

BEGIN{push @INC, '.'}

use strict;
use warnings;
use JSON_minify;

my $minifier = JSON_minify->new();
print "Processing test/simple.json ...";
$minifier->minify_file("test/simple.json", "test/resultsimple.json");
system("diff test/expectedsimple.json test/resultsimple.json");
print "Processing test/test0.json ...";
$minifier->minify_file("test/test0.json", "test/result0.json");
system("diff test/expectedresult0.json test/result0.json");
print "Processing test/test1.json ...";
$minifier->minify_file("test/test1.json", "test/result1.json");
system("diff test/expectedresult1.json test/result1.json");

