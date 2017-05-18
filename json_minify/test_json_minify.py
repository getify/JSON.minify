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
            '''
                                               \x20
            {
                "foo": "bar",                  \x20
                "bar": [
                    "baz", "bum"
                ],
                                                     \x20
                                            \x20
                "something": 10,
                "else": 20
            }

                                                                    \x20
                                                                    \x20
                                                                    \x20
              ''',
            '{"foo":"bar","bar":["baz","bum"],"something":10,"else":20}'
        ],
        [
            '''
            {"/*":"*/","//":"",/*"//"*/"/*/"://
            "//"}''',
            '''
            {"/*":"*/","//":"",        "/*/":  
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
            '''
             \x20
                    \x20
                                 {

            "foo"
            :
                "bar/*"           \x20
                ,    "b\\\"az": \x20
                             "blah"

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
            r'''
            {"foo": "ba\"r//", "bar\\": "b\\\"a/*z",
            "baz\\\\":           "fo\\\\\"*/o"
            }
            ''',
            r'{"foo":"ba\"r//","bar\\":"b\\\"a/*z","baz\\\\":"fo\\\\\"*/o"}'  # noqa
        ]
    ]

    def template(self, index):
        in_string, expected_whitespace, expected = self.tests[index - 1]
        self._space_template(in_string, expected_whitespace)

        in_dict = json.loads(json_minify(in_string))
        whitespace_dict = json.loads(json_minify(expected_whitespace))
        expected_dict = json.loads(textwrap.dedent(expected))
        self.assertEqual(in_dict, expected_dict)
        self.assertEqual(whitespace_dict, expected_dict)

    def test_1(self):
        self.template(1)

    def test_2(self):
        self.template(2)

    def test_3(self):
        self.template(3)

    def test_4(self):
        self.template(4)

    def _space_template(self, in_string, expected):
        actual = json_minify(in_string, strip_space=False)
        self.assertEqual(actual, expected)

    def test_space_keeping(self):
        self._space_template('', '')
        self._space_template('\n', '\n')
        self._space_template(' \r\n ', ' \r\n ')
        self._space_template('\t', '\t')

    def test_space_after_comments(self):
        self._space_template('//', '  ')
        self._space_template('// ', '   ')
        self._space_template('//\n ', '  \n ')
        self._space_template('//  \n ', '    \n ')
        self._space_template('/**/', '    ')
        self._space_template('/**/\n ', '    \n ')
        self._space_template('/*\n*/\n ', '  \n  \n ')

    def test_single_line_within_multi_line_comment(self):
        self._space_template('/* \n// \n */\n   ', '   \n   \n   \n   ')


if __name__ == '__main__':
    unittest.main()
