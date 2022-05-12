/*! JSON.minify()
	v3.0.0 (c) Kyle Simpson
	MIT License
*/

(function(global){
	if (typeof global.JSON == "undefined" || !global.JSON) {
		global.JSON = {};
	}

	global.JSON.minify = function JSON_minify(json) {

		var in_string = false,
			in_multiline_comment = false,
			in_singleline_comment = false,
			backslash = false,
			len = json.length,
			i = 0,
			c,
			new_str = [],
			from = 0,
			new_chars = 0,
			add_chars = 0;

		while (i < len) {
			backslash = !backslash && c == "\\"
			c = json[i++];
			if (in_singleline_comment) {
				if (c == "\r" || c == "\n") {
					in_singleline_comment = false;
				}
			}
			else if (in_multiline_comment) {
				if (c == "*") {
					if (i >= len) {
						break;
					}
					c = json[i++];
					if (c == "/") {
						in_multiline_comment = false;
					}
				}
			}
			else {
				if (c == "\"" && !backslash) {
					in_string = !in_string;
					add_chars = 1;
				}
				else if (in_string) {
					if (c != "\n" && c != "\r") {
						add_chars = 1;
					}
				}
				else {
					if (c == "/") {
						if (i >= len) {
							add_chars = 1;
							break;
						}
						backslash = !backslash && c == "\\"
						c = json[i++];
						if (c == "/") {
							in_singleline_comment = true;
						}
						else if (c == "*") {
							in_multiline_comment = true;
						}
						else {
							add_chars = 2;
						}
					}
					else if (c !== " " && c !== "\t" && c !== "\n" && c !== "\r") {
						add_chars = 1;
					}
				}
			}
			if (add_chars > 0) {
				if (new_chars == 0) {
					from = i - add_chars;
				}
				new_chars += add_chars;
				add_chars = 0;
			}
			else if (new_chars > 0) {
				new_str.push(json.substring(from, from + new_chars));
				new_chars = 0;
			}
		}
		if (new_chars > 0) {
			new_str.push(json.substring(from, from + new_chars));
		}
		return new_str.join("");
	};
})(
	// attempt to reference the global object
	typeof globalThis != "undefined" ? globalThis :
	typeof global != "undefined" ? global :
	typeof window != "undefined" ? window :
	typeof self != "undefined" ? self :
	typeof this != "undefined" ? this :
	{}
);
