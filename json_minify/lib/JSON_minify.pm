#!/usr/bin/perl
##
## JSON_minify.pm
## Copyright ©2018 Rémi Cohen-Scali
##
## Patched by Kyle Simpson, 2021
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

our $VERSION = '2.0';

package JSON_minify;

use strict;
use warnings;

sub new {
    my $class = shift;
    return bless {}, $class;
}

##
## minify_string
##
## Minify a json content available in the 2nd input parameter 'input_string'
##
sub minify_string {
    # self param: the object instance
    my $self = shift;
    # input_string param: a string containing json
    my $input_string = shift;
    # strip_space param: a boolean that specify if caller 
    # wants to strip spaces
    my $strip_space = (@_ ? shift : 1);

    # Returned value: a string containing the minified json
    my $new_str = "";
    # Current position of processing in input content
    my $index = 0;
    # Previous match index
    my $prevIndex = 0;

    # Flag indicating if processing is currently inside a multi line comment
    my $in_multi = 0;
    # Flag indicating if processing is currently inside a single line comment
    my $in_single = 0;
    # Flag indicating if processing is currently inside a string
    my $in_string = 0;
    # Flag indicating if processing is currently inside a comment (single or multi)
    my $in_comment = 0;

    # Let's iterate on every match for each token
    # This is actually a tokenization
    # Token of interrest are ", /*, */, //, \n, \r, \t, and space
    # Regex options are GLOBAL & MULTILINE
    while ($input_string =~ m/("|(\/\*)|(\*\/)|(\/\/)|[[:space:]])/gm)
    {
        # Initialize context for this match
        # First the match itself (which is group 1)
        my $token = $1;
        # Its position in the content
        my $input_pos = pos $input_string;
        # And its length.
        # FIXME: Should always match till end of string, so defined not useful anymore
        # Should replace with:
        # my $token_len = length $token;
        my $token_len = defined $token ? length $token : 1;

        # Integrate in_comment value
        $in_comment = $in_multi || $in_single;
        # if not in a comment
        if (!$in_comment)
        {
            # Get the substring between previous pos and now pos
            my $len = ($input_pos - $index - $token_len);
            # If len < 0, set to 0
            # FIXME: this was necessary because of a bug later that has been fixed.
            #        I should now be able remove it
            if ($len == -1) {$len = 0;}
            # Get the sub string
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
            $new_str .= ' ' x ($input_pos - $index - $token_len);
        }

        # Save previous index
        $prevIndex = $index;
        # As we copied the input chars, let's set index to actual position
        $index = $input_pos;
        # And get the match in a temporary
        ##my $val = $token;
        # If we are closing a string (in string, tok is a dbl quote and not in comment)
        if ($token eq '"' && ! $in_comment)
        {
            # Get the left context of the match
            my $leftcontext = substr($input_string, $prevIndex, $input_pos-1-$prevIndex);
            # Match it searching for a string of backslash (i.e. \ or \\ or \\\ etc)
            # at the end of the string
            (my $escaped = $leftcontext) =~ m/(\\)*$/;
            # Get length of match
            my $escaped_full_len = length $& || '';

            # We got a dbl quote, then
            # we are either at start of string or unescaped dbl quote (end of string)
            # if not in string, then a string is starting OR
            # in string and no backslash at all, we close the string OR
            # in string and even number of backslash (dbl quote is not backslashed)
            # then we close the string also
            if (! $in_string || ! defined $1 || ($escaped_full_len % 2 == 0))
            {
                # Then change the in string flag to its negated value
                $in_string = $in_string ? 0 : 1;
            }
            # Let's go back one char to put the dbl quote in the new_string at next iteration
            $index--;
        }
        # Else if we are neither in string nor in comment
        elsif (! ($in_string || $in_comment))
        {
            # Check that token is '/*', then start a multi comment 
            if ($token eq '/*') {$in_multi = 1; }
            # Or check that token is '//', then start a single comment 
            elsif ($token eq '//') {$in_single = 1; }
        }
        # Else if token is closing multi and we are in multi and we are not 
        # in string neither in single 
        elsif ($token eq '*/' && $in_multi && !($in_string || $in_single))
        {
            # Multi line comment reached its end: unset flag in_multi
            $in_multi = 0;
            # If we d'ont strip spaces, let's add spaces for 
            # token (same length to preserve indentation)
            if (! $strip_space) {$new_str .= ' ' x length($token);}
        }
        # Else if token is some kind of cariage return and we are not in multiline
        # comment and we are in single line comment
        elsif (($token eq "\r" || $token eq "\n") && ! $in_multi && $in_single)
        {
            # Single line comment reached its end: unset flag in_single
            $in_single = 0;
        }
        # Else if we are not in any comment at all, token is any kind of space
        # and we do not strip space
        elsif (! $in_comment || 
               (($token eq ' ' || $token eq "\r" || $token eq "\n" || $token eq "\t") && 
                ! $strip_space))
        {
            # Then add these spaces to the new string
            $new_str .= $token;
        }
        # Set in_comment flag value according to its compositing ones
        $in_comment = $in_single || $in_multi;

        # If we do not strip spaces
        if (!$strip_space)
        {
            # We need to replace separating tokens with spaces
            if ($token eq "\r" || $token eq "\n") {$new_str .= $token; }
            # or to replace comments tokens characters with spaces 
            elsif ($in_comment) {$new_str .= (' ' x length($token)); }
        }
    }
    $new_str .= substr $input_string, $index;
}

1;

__END__

=head1 NAME

JSON_minify.pm - minify a JSON and also remove comments

=head1 SYNOPSIS

 use JSON_minify;
 my $minifier = JSON_minify->new();
 my $json_string = "<a json contents with comments>";
 my $minified_json = $minifier->minify_string($json_string, 0);

=head1 DESCRIPTION

 This module provides a unique method for minifying a json string. This 
 string may eventually contains some C/C++ like comments. The minify_string
 method accept two arguments. First the json content as a string, and a
 boolean for striping_space (default is: space stripped).

=head2 Exports
 
=over

=item :minify_string 

=back

=cut

