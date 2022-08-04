package minify

import (
	"bytes"
	"testing"
)

type Test struct {
	Before string;
	Expected string;
}

func TestRemoveComments(t *testing.T) {
	tests := []Test {
	{
		Before: `
			// this is a JSON file with comments
			{
				"foo": "bar",	// this is cool
				"bar": [
					"baz", "bum", "zam"
				],
			/* the rest of this document is just fluff
			   in case you are interested. */
				"something": 10,
				"else": 20
			}

			/* NOTE: You can easily strip the whitespace and comments
			   from such a file with the JSON.minify() project hosted
			   here on github at http://github.com/getify/JSON.minify
			*/`,
		Expected: `{"foo":"bar","bar":["baz","bum","zam"],"something":10,"else":20}`,
	},
	{
		Before: `

			{"/*":"*/","//":"",/*"//"*/"/*/"://
			"//"}
			`,
		Expected: `{"/*":"*/","//":"","/*/":"//"}`,
	},
	{
		Before: `
			/*
			this is a
			multi line comment */{

			"foo"
			:
				"bar/*"// something
				,	"b\\\"az":/*
			something else */"blah"

			}`,
		Expected: `{"foo":"bar/*","b\\\"az":"blah"}`,
	},
	{
		Before: `
			{"foo": "ba\\\"r//", "bar\\\\": "b\\\\\\\"a/*z",
				"baz\\\\\\\\": /* yay */ "fo\\\\\\\\\\\"*/o"
			}`,
		Expected: `{"foo":"ba\\\"r//","bar\\\\":"b\\\\\\\"a/*z","baz\\\\\\\\":"fo\\\\\\\\\\\"*/o"}`,
	}};

	for _, test := range tests {
		after := JsonMinify(test.Before, true)
		if !bytes.Equal([]byte(after), []byte(test.Expected)) {
			t.Fatalf("Not the same:\nreal:    %s\nExpected:%s\n", after, test.Expected)
		}
	}
}
