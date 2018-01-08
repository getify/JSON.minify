#/usr/bin/perl

package JSON_minify;

use strict;
use warnings;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub minify_string {
    my $self = shift;
    my $input_string = shift;
    my $strip_space = shift || 1;

    my $new_str = "";
    my $index = 0;

    my $in_multi = 0;
    my $in_single = 0;
    my $in_string = 0;

    while ($input_string =~ m/"|(\/\*)|(\*\/)|(\/\/)|\n|\r/g)
    {
        my $group = $1;
        my $input_pos = pos $input_string;
        my $group_len = defined $group ? length $group : 0;
        if (!$in_multi || $in_single)
        {
            my $tmp = substr $input_string, 0, $input_pos;
            if (! $in_string && $strip_space)
            {
                $tmp =~ s/[[:space:]]+//g;
            }
            $new_str .= $tmp;
        }
        elsif (! $strip_space)
        {
            $new_str .= ' ' x (pos($input_string) - $index);
        }
        $index = $input_pos + $group_len;
        my $val = $group;

        if ($val eq '"' && ! ($in_multi || $in_single))
        {
            (my $escaped = $input_string) =~ m/(\\)*$/;
            if (! $in_string || ($group_len % 2 == 0))
            {
                $in_string = ! $in_string;
            }
            $index--;
        }
        elsif (! ($in_string || $in_multi || $in_single))
        {
            if ($val eq '/*') {$in_multi = 1;}
            elsif ($val eq '//') {$in_single = 1;}
        }
        elsif ($val eq '*/' && $in_multi && !($in_string || $in_single))
        {
            $in_multi = 0;
            if (! $strip_space) {$new_str .= ' ' x length($val);}
        }
        elsif (($val eq '\r' || $val eq '\n') && ! ($in_multi || $in_string) && $in_single)
        {
            $in_single = 0;
        }
        elsif (! ($in_multi || $in_single) || 
               (($val eq ' ' || $val eq '\r' || $val eq '\n' || $val eq '\t') && $strip_space))
        {
            $new_str .= $val;
        }

        if (!$strip_space)
        {
            if ($val eq '\r' || $val eq '\n')
            {
                $new_str .= $val;
            }
            elsif ($in_multi || $in_single)
            {
                $new_str .= (' ' x length($val));
            }
        }
    }

    $new_str .= substr $input_string, $index;
    print "$new_str\n";
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
