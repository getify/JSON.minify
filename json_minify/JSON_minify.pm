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
#        print "============================================================================\n";
#        print "input_string='$input_string'\n";
        my $group = $1;
#        print "group = '$group'\n";
        my $input_pos = pos $input_string;
#        print "input pos = $input_pos\n";
        my $group_len = defined $group ? length $group : 1;
#        print "group len = $group_len\n";
#        print "index = $index\n";
#        print "first if: in_multi=$in_multi in_single=$in_single in_string=$in_string in_comment=$in_comment\n";
        $in_comment = $in_multi || $in_single;
        # if not in a comment
        if (!$in_comment)
        {
            # Get the sub string between previous pos and now pos
            my $len = ($input_pos - $index - $group_len);
#            print "    in first if: len = $len\n";
            if ($len == -1) {$len = 0;}
#            print "    in first if: after len = $len\n";
            my $tmp = substr $input_string, $index, $len;
#            print "    in first if: tmp = '$tmp'\n";
            ## Eventually strip spaces
            if (! $in_string && $strip_space)
            {
                $tmp =~ s/[[:space:]]*//gm;
#                print "    in first if: strip space: tmp = '$tmp'\n";
            }
            # And add it in final result
            $new_str .= $tmp;
#            print "    in first if: new_str = '$new_str'\n";
        }
        # Else if not in comment and not stripping spaces
        elsif (! $strip_space)
        {
            # we replace the substring with spaces
            $new_str .= ' ' x ($input_pos - $index - $group_len);
#            print "    in 2nd if: new_str = '$new_str'\n";
        }
#        print "after first if group: index=$index\n";
        $index = $input_pos + $group_len - 1;
#        print "after first if group: new index=$index\n";
        my $val = $group;
        
#        print "after first if group: val='$val'\n";

#        print "second if group: in_multi=$in_multi in_single=$in_single in_string=$in_string in_comment=$in_comment\n";
#        print "val=='\\r' ?: ".($val eq "\r" ? "yes" : "no")."\n";
#        print "val=='\\n' ?: ".($val eq "\n" ? "yes" : "no")."\n";
#        print "val=='\\r\\n' ?: ".($val eq "\r\n" ? "yes" : "no")."\n";
#        print "val=='\\n\\r' ?: ".($val eq "\n\r" ? "yes" : "no")."\n";
        # If we are closing a string (in string, tok is a dbl quote and not in comment)
        if ($val eq '"' && ! $in_comment)
        {
            (my $escaped = substr( $input_string, $index, ($input_pos - $index - $group_len))) =~ m/(\\)*$/;
            my $escaped_group = $1 || '';
            my $escaped_group_len = length $escaped_group;
#            print "    in 3rd if: escaped='$escaped'\n";
#            print "    in 3rd if: escaped_group='$escaped_group'\n";
#            print "    in 3rd if: escaped_group_len=$escaped_group_len\n";
#            print "    in 3rd if: escaped_group_len %2 = ".($escaped_group_len % 2)."\n";
            # We are either at start of string or unescaped dbl quote (end of string)
            if (! $in_string || ! defined $1 || ($escaped_group_len % 2 == 0))
            {
#                print "    in if of 3rd if: in_string=$in_string\n";
                $in_string = $in_string ? 0 : 1;
#                print "    in if of 3rd if: new in_string=$in_string\n";
            }
            $new_str .= '"';
#            print "    in if of 3rd if: new_str='$new_str'\n";
        }
        elsif (! ($in_string || $in_comment))
        {
#            print "    in 4th if: val='$val'\n";
            if ($val eq '/*') {$in_multi = 1; }
            elsif ($val eq '//') {$in_single = 1; }
        }
        elsif ($val eq '*/' && $in_multi && !($in_string || $in_single))
        {
#            print "    in 5th if: unset in_multi\n";
            $in_multi = 0;
            if (! $strip_space) 
            {
                $new_str .= ' ' x length($val);
#                print "    in 5th if: new_str='$new_str'\n";
            }
        }
        elsif (($val eq "\r" || $val eq "\n") && ! $in_multi && $in_single)
        {
#            print "    in 6th if: unset in_single\n";
            $in_single = 0;
        }
        elsif (! $in_comment || 
               (($val eq ' ' || $val eq "\r" || $val eq "\n" || $val eq "\t") && !$strip_space))
        {
            $new_str .= $val;
#            print "    in 7th if: new_str='$new_str'\n";
        }
        $in_comment = $in_single || $in_multi;

        if (!$strip_space)
        {
#            print "    in 8th if: val='$val'\n";
            if ($val eq '\r' || $val eq '\n')
            {
                $new_str .= $val;
#                print "    in 8th if: new_str='$new_str'\n";
            }
            elsif ($in_multi || $in_single)
            {
                $new_str .= (' ' x length($val));
#                print "    in 8th if: new_str='$new_str'\n";
            }
        }
        
#        print "new_str='$new_str'\n";
    }

#    print "END: index=$index\n";
    $new_str .= substr $input_string, $index;
#    print "END: substr input_string, index=".(substr $input_string, $index)."\n";
}

1;
