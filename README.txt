/*! JSON.minify()
	v0.1 (c) Kyle Simpson
	MIT License
*/

JSON.minify() minifies blocks of JSON by removing all whitespace *and* comments.

JSON.parse() does not consider JSON with comments to be valid and parseable. So,
the intended usage is to minify development-friendly JSON (with comments) to
valid JSON before parsing, such as:

JSON.parse(JSON.minify(str));

Now you can maintain development-friendly JSON documents, but minify them before
parsing or before transmitting them over-the-wire.