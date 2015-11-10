# Porting to other languages
As can be seen by comparing the [PHP port][php-port], the spirit is to implement the same (as as close as possible) algorithm as in the original JS code, until we're more sure the algorithm is either solid (bug free) or perhaps we decide on a better universal algorithm.

But the more similar the code algorithm implementations are, the easier it will be to maintain the various ports if changes must occur.

In as much as possible, please prefer to use core/built-in parts of each language rather than 3rd party packages/plugins. That reduces the entry-barrier for most people and also reduces dependencies. If that's not practical in some situation, be sure to document the same. But if possible, that's preferred.

The tests.txt file shows 4 different test inputs which exercise the algorithm and show the correct outputs. Those same tests should pass for all implementations.

To contribute a port, Fork and base (or rebase) your work off the `base` branch and add the files, and then send me a pull request, with the language name in the title of the PR.

 [php-port]: https://github.com/getify/JSON.minify/tree/php
