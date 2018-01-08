#!/usr/bin/perl

BEGIN{push @INC, '.'}

use strict;
use warnings;
use JSON_minify;

##
## Test input strings
##
my $in_str1 = "{\n    // COMMENT\n    \"key1\": /* COMMENT */ \"value1\",\n    \"key2\": 4, /*COMMENT*/\n    \"key3\": false,\n    /* COMMENT\n     * COMMENT\n     * COMMENT */\n    \"key4\": /*\n    COMMENT\n */ [\n        \"str1\", \"str2\", \"str3\"\n    ],\n    \"key5\" : // COMMENT\n    {\n        \"key51\": \"test \",\n        \"key52\": \"test /* */ test \"\n    }\n}\n";
my $in_str2 = "\
			// this is a JSON file with comments\n\
			{\n\
				\"foo\": \"bar\",	// this is cool\n\
				\"bar\": [\n\
					\"baz\", \"bum\", \"zam\"\n\
				],\n\
			/* the rest of this document is just fluff\n\
			   in case you are interested. */\n\
				\"something\": 10,\n\
				\"else\": 20\n\
			}\n\
			\n\
			/* NOTE: You can easily strip the whitespace and comments\n\
			   from such a file with the JSON.minify() project hosted\n\
			   here on github at http://github.com/getify/JSON.minify\n\
    */\n";
my $in_str3 = "\
    \n\
    {\"/*\":\"*/\",\"//\":\"\",/*\"//\"*/\"/*/\"://\n\
    \"//\"}\n\
    \n";
my $in_str4 = "\
    /*\n\
    this is a\n\
    multi line comment */{\n\
    \n\
    \"foo\"\n\
    :\n\
    \"bar/*\"// something\n\
    ,	\"b\\\"az\":/*\n\
    something else */\"blah\"\n\
    \n\
}\n";
my $in_str5 = "\
{\"foo\": \"ba\\\"r//\", \"bar\\\\\": \"b\\\\\\\"a/*z\",\n\
    \"baz\\\\\\\\\": /* yay */ \"fo\\\\\\\\\\\"*/o\"\n\
}\n";

##
## Test output strings
##
my $out_str1 = '{"key1":"value1","key2":4,"key3":false,"key4":["str1","str2","str3"],"key5":{"key51":"test ","key52":"test /* */ test "}}';
my $out_str2 = "{\"foo\":\"bar\",\"bar\":[\"baz\",\"bum\",\"zam\"],\"something\":10,\"else\":20}";
my $out_str3 = "{\"/*\":\"*/\",\"//\":\"\",\"/*/\":\"//\"}";
my $out_str4 = "{\"foo\":\"bar/*\",\"b\\\"az\":\"blah\"}";
my $out_str5 = "{\"foo\":\"ba\\\"r//\",\"bar\\\\\":\"b\\\\\\\"a/*z\",\"baz\\\\\\\\\":\"fo\\\\\\\\\\\"*/o\"}";

##
## Ok let's instantiate
##
my $minifier = JSON_minify->new();

##
## Test 1
##
my $ret_str1 = $minifier->minify_string($in_str1);
if ($out_str1 eq $ret_str1)
{
    print "test1: OK!\n";
}
else
{
    print "test1: FAILED!\n";
}

##
## Test 2
##
my $ret_str2 = $minifier->minify_string($in_str2);
if ($out_str2 eq $ret_str2)
{
    print "test2: OK!\n";
}
else
{
    print "test2: FAILED!\n";
}

##
## Test 3
##
my $ret_str3 = $minifier->minify_string($in_str3);
if ($out_str3 eq $ret_str3)
{
    print "test3: OK!\n";
}
else
{
    print "test3: FAILED!\n";
}

##
## Test 4
##
my $ret_str4 = $minifier->minify_string($in_str4);
if ($out_str4 eq $ret_str4)
{
    print "test4: OK!\n";
}
else
{
    print "test4: FAILED!\n";
}

##
## Test 5
##
my $ret_str5 = $minifier->minify_string($in_str5);
if ($out_str5 eq $ret_str5)
{
    print "test5: OK!\n";
}
else
{
    print "test5: FAILED!\n";
}
