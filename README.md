# JSON-minify

A port of the `JSON-minify` utility to the LabVIEW (G) language.

This code was developed using the [LabVIEW 2020 SP1 Free Community Edition](https://www.ni.com/pt-br/shop/labview/select-edition/labview-community-edition.html).

## Overview

`JSON-minify` minifies blocks of JSON-like content into valid JSON by removing all whitespace *and* JS-style comments (single-line `//` and multiline `/* .. */`).

With `JSON-minify`, you can maintain developer-friendly JSON documents, but minify them before parsing or transmitting them over-the-wire.

## Porting

Please see [PORTING.md](PORTING.md) for instructions.

## Testing

This project uses for test the [Caraya Unit Test Framework](https://github.com/JKISoftware/Caraya).

Please see [TESTING.md](TESTING.md) for example tests.

## License

The code and all the documentation are released under the MIT license.

http://getify.mit-license.org/
