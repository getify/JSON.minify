JSON-minify
============

A port of the `JSON-minify` utility to the Perl language.

Overview
--------

`JSON_minify.pm` minifies blocks of JSON-like content into valid JSON by removing
all whitespace *and* JS-style comments (single-line `//` and multi-line
`/* .. */`).

With `JSON_minify.pl`, you can maintain developer-friendly JSON documents, but
minify them before parsing or transmitting them over-the-wire.

Installation
------------

You can install using Perl standard Makefile.PL as follows::

     perl Makefile.PL
     make

If you wish to use the development version of JSON_minify.pm, you can install it
as follows::

     make install


Testing
-------

Test are automatically run when build as the standard procedure for Perl packahe distribution


License
-------

The code and all the documentation are released under the MIT license.

http://getify.mit-license.org/
