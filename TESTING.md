# Tests for JSON.minify

#### Test 1

```js
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
*/
```

Expected Result:

```js
{"foo":"bar","bar":["baz","bum","zam"],"something":10,"else":20}
```

-----

#### Test 2

```js

{"/*":"*/","//":"",/*"//"*/"/*/"://
"//"}

```

Expected Result:
```js
{"/*":"*/","//":"","/*/":"//"}
```

-----

#### Test 3

```js
/*
this is a
multi line comment */{

"foo"
:
	"bar/*"// something
	,	"b\"az":/*
something else */"blah"

}
```

Expected Result

```js
{"foo":"bar/*","b\"az":"blah"}
```

-----

#### Test 4

```js
{"foo": "ba\"r//", "bar\\": "b\\\"a/*z",
	"baz\\\\": /* yay */ "fo\\\\\"*/o"
}
```

Expected Result

```js
{"foo":"ba\"r//","bar\\":"b\\\"a/*z","baz\\\\":"fo\\\\\"*/o"}
```
