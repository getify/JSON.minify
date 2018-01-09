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
use Getopt::Long;
use Pod::Usage;
use Data::Dumper qw(Dumper);
use JSON_minify;

my $output = '-';
my $help = 0;
my $man = 0;
my $strip = 0;

GetOptions (
    "output|o=s" => \$output, 
    "help|h+"   => \$help, 
    "man|m+"   => \$man, 
    "strip|s!"  => \$strip)  
    or pod2usage(2);  # flag
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub minify_file {
    my $fhi = shift;
    my $fho = shift;
    my $strip = shift;

    binmode $fhi;
    my $clang_tidy;
    while (<$fhi>)
    {
        $clang_tidy .= $_;
    }
    close ($fhi);
    
    my $minifier = JSON_minify->new();
    $fho->print($minifier->minify_string($clang_tidy, $strip));
}

my $fhi;
my $fho;

if ($output eq '-')
{
    $fho = \*STDOUT;
}
else
{
    open($fho, "<:encoding(UTF-8)", $output)
        or die "Error: Cannot open '$output' for writing: $!\n";
}

Dumper(@ARGV);

if (scalar @ARGV == 0)
{
    $fhi = \*STDIN;
    minify_file($fhi, $fho, $strip);
}
else
{
    foreach my $fname (@ARGV)
    {
        open($fhi, "<:encoding(UTF-8)", $fname)
            or warn "Error: Cannot open '$fname' for reading: $!\n";
        minify_file($fhi, $fho, $strip);
    }
}

__END__

=head1 NAME

    json_minify.pl - Command interface for JSON_minify module

=head1 SYNOPSIS

    json_minify.pl [options] [file [file ...]]

    If no file is provided as option arguments, the strandard input
    is used.
    Options:
       --output | -o <output-file>     output file
       --strip | -s                    strip spaces
       --help  | -h                    brief help message
       --man  | -m                     full documentation message

=head1 OPTIONS

=over 8

=item B<--output|-o>

    Specify the pathname for an output file.
    If no output file is provided, result is sent
    on standard output.

=item B<--strip|-s>

    Allows to strip spaces from the json content stream

=item B<--help|-h>

    Print a brief help message and exits.

=item B<--man|-m>

    Prints the manual page and exits.

=back

=head1 DESCRIPTION

    B<JSON_minify.pl> will read the given input file(s) and will process it
    in order to removed C:C++ comments.

=cut
