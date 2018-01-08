#/usr/bin/perl

package JSON_minify;

use strict;
use warnings;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub minify_string {
}

sub minify_file {
    my $self = shift;
    my $fi = shift;
    my $fo = shift;

    my $fin;
    my $fout;
    
    open($fin, '<:encoding(UTF-8)', $fi)
        or die "Cannot open file '$fi' for reading: $!";
    open($fout, '>:encoding(UTF-8)', $fo)
        or die "Cannot open file '$fo' for writing: $!";
    my $oc = 0;
    while (<$fin>) {
        chomp;
        s/\/\*([^*][^\/]|[^"])*\*\///g;
        if (m/^([^\/][^*]|[^"])*\*\// && $oc == 1) { $oc = 0;}
        if (m/\/\*([^*][^\/]|[^"])*$/ && $oc == 0) { $oc = 1;}
        s/\/\*([^*][^\/]|[^"])*$//;
        s/^([^*][^\/]|[^"])*\*\///;
        s/\s*\/\/.*$//g;
        s/\s+//g;
        if ($oc == 0) {$fout->print("$_");}
        
    }
}

sub minify_handler {
    my $self = shift;

    my $fhi = shift;
    my $fho = shift;
    my $oc = 0;
    while (<$fhi>) {
        chomp;
        s/\/\*([^*][^\/]|.)*\*\///g;
        if (m/^([^\/][^*]|.)*\*\// && $oc == 1) { $oc = 0;}
        if (m/\/\*([^*][^\/]|.)*$/ && $oc == 0) { $oc = 1;}
        s/\/\*([^*][^\/]|.)*$//;
        s/^([^*][^\/]|.)*\*\///;
        s/\s*\/\/.*$//g;
        s/\s+//g;
        if ($oc == 0) {$fho->print("$_");}
        
    }
}

1;
