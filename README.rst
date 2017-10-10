JSON-minify
============

A port of the `JSON-minify` utility to the Python language.

Overview
--------

`JSON-minify` minifies blocks of JSON-like content into valid JSON by removing
all whitespace *and* JS-style comments (single-line `//` and multi-line
`/* .. */`).

With `JSON-minify`, you can maintain developer-friendly JSON documents, but
minify them before parsing or transmitting them over-the-wire.

Installation
------------

You can install using pip as follows::

     pip install JSON-minify

If you wish to use the development version fo JSON-minify, you can install it
as follows::

     pip install git+https://github.com/getify/JSON.minify@python


Testing
-------

To run the tests, just execute json_minify.py.

::

    python json_minify.py

License
-------

The code and all the documentation are released under the MIT license.

http://getify.mit-license.org/
