'''
Created on 20/01/2011

v0.2 (C) Gerald Storer
MIT License

Based on JSON.minify.js:
https://github.com/getify/JSON.minify

Contributers:
 - Pradyun S. Gedam (conditions and variable names changed)
'''

import unittest2 as unittest
import json
import textwrap
from json_minify.lib import json_minify


class JsonMinifyTestCase(unittest.TestCase):
    """Tests for json_minify"""
    def template(self, in_string, expected):
        in_dict = json.loads(json_minify(in_string))
        expected_dict = json.loads(expected)
        self.assertEqual(in_dict, expected_dict)

    def test_1(self):
        self.template(textwrap.dedent(
            '''
            // this is a JSON file with comments
            {
                "foo": "bar",    // this is cool
                "bar": [
                    "baz", "bum"
                ],
            /* the rest of this document is just fluff
               in case you are interested. */
                "something": 10,
                "else": 20
            }

            /* NOTE: You can easily strip the whitespace and comments
               from such a file with the JSON.minify() project hosted
               here on github at http://github.com/getify/JSON.minify
            */'''),
            '{"foo":"bar","bar":["baz","bum"],"something":10,"else":20}'
        )

    def test_2(self):
        self.template(textwrap.dedent(
            '''
            {"/*":"*/","//":"",/*"//"*/"/*/"://
            "//"}'''),
            '{"/*":"*/","//":"","/*/":"//"}'
        )

    def test_3(self):
        self.template(textwrap.dedent(
            r'''
            /*
            this is a
            multi line comment */{

            "foo"
            :
                "bar/*"// something
                ,    "b\"az":/*
            something else */"blah"

            }
            '''),
            r'{"foo":"bar/*","b\"az":"blah"}'
        )

    def test_4(self):
        self.template(textwrap.dedent(
            r'''
            {"foo": "ba\"r//", "bar\\": "b\\\"a/*z",
            "baz\\\\": /* yay */ "fo\\\\\"*/o"
            }
            '''),
            r'{"foo":"ba\"r//","bar\\":"b\\\"a/*z","baz\\\\":"fo\\\\\"*/o"}'
        )

