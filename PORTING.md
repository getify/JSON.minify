# Porting JSON-minify

Thanks for agreeing to help port this utility to another language!

Please keep the following things in mind:

 1. A language port should maintain the same semantics as the main JS utility, which is that it should remove all whitespace and all JS-style comments (single-line and multiline), and nothing more. **Please do not diverge from these semantics** unless you've first discussed it and the maintainer(s) has (have) agreed. Any substantial feature deviation should be ported to all other languages in this repo.

 2. File an issue on the repo discussing what language you want to port to, and any design issues which may apply to that specific language (the language doesn't have arrays, etc.).
 
 3. Once a language port is decided and planned, the maintainer(s) will create a main repo branch for the new language port, which will be a forked branch off the empty "base" branch as its starting point. An issues tag will also be created for the language.
 
 4. A language port must start from this empty language branch. A language branch should be fully self-contained (including all tests, documentation, etc.). Files/folders in the language branch should be named and organized in a common idiomatic way for the language in question, including consistent use of language styles (whitespace, comments, etc.). See other language branches for inspiration.
 
 5. A workable implementation must at least pass all the tests as listed in [TESTING.md](TESTING.md).
 
 6. Once a workable implementation for the language port is in place (including tests, documentation, etc.), submit a PR from your language branch to the main repo language branch (**not master!**), and we'll go from there!

 7. To be accepted to the main repo, the port (code and documentation) must be licensed with the liberal MIT license (see the JS and PHP branches), though you are free to retain your own copyright message.

Thanks, again!
