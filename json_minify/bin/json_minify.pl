#!/usr/bin/perl
##
## json_minify.pl
## Copyright ©2018 Rémi Cohen-Scali
##
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the “Software”), to 
## deal in the Software without restriction, including without limitation the 
## rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
## sell copies of the Software, and to permit persons to whom the Software is 
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
## FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
## IN THE SOFTWARE.
##

##
## Script allowing to process a json file/stream
##
## usage: json_minify.pl -i <afile>.json -o <anoutfile>.json
##        cat <afile.json> | json_minify.pl > <anoutfile>.json
##        cat <afile.json> | json_minify.pl -o <anoutfile>.json
##        json_minify.pl -i <afile>.json > <anoutfile>.json
##
## -s|--strip for stripping spaces
##


## !!Now only a placeholder until I write it...!

our $VERSION = '1.0';



BEGIN{push @INC, '/home/cohen/Sources/JSON-minify/json_minify/lib'}

use strict;
use warnings;
use JSON_minify;

my $fhi;
open($fhi, "<:encoding(UTF-8)", $::main::ARGV[0])
    or die "Error: Cannot open '".$::main::ARGV[0]."': $!\n";
binmode $fhi;
my $clang_tidy;
while (<$fhi>)
{
    $clang_tidy .= $_;
}
close ($fhi);

my $minifier = JSON_minify->new();
print $minifier->minify_string($clang_tidy, 0);
