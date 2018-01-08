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

my $in_str = '{\n    // COMMENT\n    "key1": /* COMMENT */ "value1",\n    "key2": 4, /*COMMENT*/\n    "key3": false,\n    /* COMMENT\n     * COMMENT\n     * COMMENT */\n    "key4": /*\n    COMMENT\n */ [\n        "str1", "str2", "str3"\n    ],\n    "key5" : // COMMENT\n    {\n        "key51": "test ",\n        "key52": "test /* */ test "\n    }\n}\n';
my $out_str = '{"key1":"value1","key2":4,"key3": false,"key4":["str1","str2","str3"],"key5":{"key51":"test ","key52":"test /* */ test "}}';
my $ret_str = $minifier->minify_string($in_str);
