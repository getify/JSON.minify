# JSON minify

Minify blocks of JSON-like content into valid JSON by removing all white-space *and* C/C++ style comments.

JSON parsers (like JavaScript's `JSON.parse()` parser) generally don't consider JSON with comments to be valid and parseable. So, the intended usage is of this project is to minify development-friendly JSON (i.e with comments) to valid JSON before parsing, such as:

```js
JSON.parse(JSON.minify(str))
```

Now you can maintain development-friendly JSON documents, where your source is formatted & commented, but minify them before parsing or before transmitting them over-the-wire.

As transmitting bloated (ie, with comments/white-space) JSON would be wasteful and silly, this JSON minify can also be used for server-side processing environments where you can strip comments/white-space from JSON before parsing a JSON document or before transmitting such over-the-wire from server to browser.

Though comments are not officially part of the JSON standard, [this][yahoo-groups-link] post from Douglas Crockford back in late 2005 helps explain the motivation behind this project.

> A JSON encoder MUST NOT output comments. A JSON decoder MAY accept and ignore comments.

Basically, comments are not in the JSON *generation* standard, but that doesn't mean that a parser can't be taught to ignore them. Which is exactly what JSON minify is for.

The first implementation of JSON minify was in JavaScript (as `JSON.minify`), but the intent is to port the implementation to as many other environments and languages as possible/practical.

## Using JSON Minify
Currently, JSON minify has been ported to multiple languages including PHP, Python, Objective C. Each of these ports live on a separate branch in the [Github repository][repo-link]. Language specific instructions can be found in their respective branches.

 [yahoo-groups-link]: http://web.archive.org/web/20130101004216/http://tech.groups.yahoo.com/group/json/message/152
 [php-port]: https://github.com/getify/JSON.minify/tree/php
 [repo-link]: https://github.com/getify/JSON.minify
