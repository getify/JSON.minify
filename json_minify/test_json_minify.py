"""Tests for json_minify
"""

# Python 2.6+ needed to run tests
import json
import textwrap
import unittest

from json_minify import json_minify


class JsonMinifyTestCase(unittest.TestCase):
    """Tests for json_minify"""

    tests = [
        [
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
            */''',
            '{"foo":"bar","bar":["baz","bum"],"something":10,"else":20}'
        ],
        [
            '''
            {"/*":"*/","//":"",/*"//"*/"/*/"://
            "//"}''',
            '{"/*":"*/","//":"","/*/":"//"}'
        ],
        [
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
            ''',
            r'{"foo":"bar/*","b\"az":"blah"}'
        ],
        [
            r'''
            {"foo": "ba\"r//", "bar\\": "b\\\"a/*z",
            "baz\\\\": /* yay */ "fo\\\\\"*/o"
            }
            ''',
            r'{"foo":"ba\"r//","bar\\":"b\\\"a/*z","baz\\\\":"fo\\\\\"*/o"}'  # noqa
        ]
    ]

    def template(self, in_string, expected):
        in_dict = json.loads(json_minify(in_string))
        expected_dict = json.loads(textwrap.dedent(expected))
        self.assertEqual(in_dict, expected_dict)

    def test_1(self):
        self.template(*self.tests[0])

    def test_2(self):
        self.template(*self.tests[1])

    def test_3(self):
        self.template(*self.tests[2])

    def test_4(self):
        self.template(*self.tests[3])

if __name__ == '__main__':
    unittest.main()
