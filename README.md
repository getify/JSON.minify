# JSON-minify

A port of the `JSON-minify` utility to the Python language.

## Overview

`JSON-minify` minifies blocks of JSON-like content into valid JSON by removing all whitespace *and* JS-style comments (single-line `//` and multiline `/* .. */`).

With `JSON-minify`, you can maintain developer-friendly JSON documents, but minify them before parsing or transmitting them over-the-wire.

## Testing
To run the tests, just execute json_minify.py, i.e.

    python json_minify.py

## License

The code and all the documentation are released under the MIT license.

http://getify.mit-license.org/
