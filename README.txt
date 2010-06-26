/*! JSON.minify()
	v0.1 (c) Kyle Simpson
	MIT License
*/

JSON.minify() minifies blocks of JSON-like content into valid JSON by removing all 
whitespace *and* comments.

JSON.parse() does not consider JSON with comments to be valid and parseable. So,
the intended usage is to minify development-friendly JSON (with comments) to
valid JSON before parsing, such as:

JSON.parse(JSON.minify(str));

Now you can maintain development-friendly JSON documents, but minify them before
parsing or before transmitting them over-the-wire.

NOTE: As transmitting bloated (ie, with comments/whitespace) JSON would be wasteful
and silly, this JSON.minify() is intended for use in server-side JavaScript
environments where you can strip comments/whitespace from JSON before parsing
a JSON document, or before transmitting such over-the-wire from server to browser.

NOTE #2: Though comments are not officially part of the JSON standard, this post from
Douglas Crockford back in late 2005 helps explain the motivation behind this project.

http://tech.groups.yahoo.com/group/json/message/152

"A JSON encoder MUST NOT output comments. A JSON decoder MAY accept and ignore comments."

Basically, comments are not in the JSON *creation* standard, but that doesn't mean
that a parser can't be taught to ignore them. Which is exactly what JSON.minify()
is for.