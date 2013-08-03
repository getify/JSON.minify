/*!
 * `JSON.minify()`
 * This version does not use regular expressions.
 *
 * Copyright 2011, Kyle Simpson.
 * Copyright 2012, Kit Cambridge.
 *
 * Released under the MIT License.
*/

;(function () {
  var JSON = this.JSON;

  // Create the global JSON object if it doesn't exist.
  if (Object(JSON) !== JSON) {
    JSON = this.JSON = {};
  }

  JSON.minify = function (source) {
    var index = 0, length = source.length, result = "", symbol, position;
    while (index < length) {
      symbol = source.charAt(index);
      switch (symbol) {
        // Ignore whitespace tokens. According to ES 5.1 section 15.12.1.1,
        // whitespace tokens include tabs, carriage returns, line feeds, and
        // space characters.
        // -----------------------------------------------------------------
        case "\t":
        case "\r":
        case "\n":
        case " ":
          index += 1;
          break;
        // Ignore line and block comments.
        // -------------------------------
        case "/":
          symbol = source.charAt(index += 1);
          switch (symbol) {
            // Line comments.
            // -------------
            case "/":
              position = source.indexOf("\n", index);
              if (position < 0) {
                // Check for CR-style line endings.
                position = source.indexOf("\r", index);
              }
              index = position > -1 ? position : length;
              break;
            // Block comments.
            // ---------------
            case "*":
              position = source.indexOf("*/", index);
              if (position > -1) {
                // Advance the scanner's position past the end of the comment.
                index = position += 2;
                break;
              }
              throw SyntaxError("Unterminated block comment.");
            default:
              throw SyntaxError("Invalid comment.");
          }
          break;
        // Parse strings separately to ensure that any whitespace characters and
        // JavaScript-style comments within them are preserved.
        // ---------------------------------------------------------------------
        case '"':
          position = index;
          while (index < length) {
            symbol = source.charAt(index += 1);
            if (symbol == "\\") {
              // Skip past escaped characters.
              index += 1;
            } else if (symbol == '"') {
              break;
            }
          }
          if (source.charAt(index) == '"') {
            result += source.slice(position, index += 1);
            break;
          }
          throw SyntaxError("Unterminated string.");
        // Preserve all other characters.
        // ------------------------------
        default:
          result += symbol;
          index += 1;
      }
    }
    return result;
  };
}).call(this);