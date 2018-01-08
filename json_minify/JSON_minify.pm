#!/usr/bin/perl

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
    my $in_comment = 0;

    while ($input_string =~ m/("|(\/\*)|(\*\/)|(\/\/)|[[:space:]])/gm)
    {
        # Initialize context
        my $group = $1;
        my $input_pos = pos $input_string;
        my $group_len = defined $group ? length $group : 1;

        $in_comment = $in_multi || $in_single;
        # if not in a comment
        if (!$in_comment)
        {
            # Get the sub string between previous pos and now pos
            my $len = ($input_pos - $index - $group_len);
            if ($len == -1) {$len = 0;}
            my $tmp = substr $input_string, $index, $len;
            
            ## Eventually strip spaces
            if (! $in_string && $strip_space) {$tmp =~ s/[[:space:]]*//gm;}
            # And add it in final result
            $new_str .= $tmp;
        }
        # Else if not in comment and not stripping spaces
        elsif (! $strip_space)
        {
            # we replace the substring with spaces
            $new_str .= ' ' x ($input_pos - $index - $group_len);
        }
        $index = $input_pos;
        my $val = $group;
        # If we are closing a string (in string, tok is a dbl quote and not in comment)
        if ($val eq '"' && ! $in_comment)
        {
            my $leftcontext = substr($input_string, 0, $input_pos-1);
            (my $escaped = $leftcontext) =~ m/(\\)*$/;
            my $escaped_full_len = length $& || '';

            # We are either at start of string or unescaped dbl quote (end of string)
            if (! $in_string || ! defined $1 || ($escaped_full_len % 2 == 0))
            {
                $in_string = $in_string ? 0 : 1;
            }
            $index--;
        }
        elsif (! ($in_string || $in_comment))
        {
            if ($val eq '/*') {$in_multi = 1; }
            elsif ($val eq '//') {$in_single = 1; }
        }
        elsif ($val eq '*/' && $in_multi && !($in_string || $in_single))
        {
            $in_multi = 0;
            if (! $strip_space) {$new_str .= ' ' x length($val);}
        }
        elsif (($val eq "\r" || $val eq "\n") && ! $in_multi && $in_single)
        {
            $in_single = 0;
        }
        elsif (! $in_comment || 
               (($val eq ' ' || $val eq "\r" || $val eq "\n" || $val eq "\t") && 
                !$strip_space))
        {
            $new_str .= $val;
        }
        $in_comment = $in_single || $in_multi;

        if (!$strip_space)
        {
            if ($val eq '\r' || $val eq '\n') {$new_str .= $val; }
            elsif ($in_multi || $in_single) {$new_str .= (' ' x length($val)); }
        }
    }
    $new_str .= substr $input_string, $index;
}

1;
