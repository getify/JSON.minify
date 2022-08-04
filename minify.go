package minify

import (
	"strings"
)

func JsonMinify(json string, stripSpace bool) string {
	var out strings.Builder
	indexMultilineComment := -1
	indexInlineComment := -1
	inJsonStr := false
	skip := false
	for i, r := range json {
		if skip {
			skip = false
			continue
		}
		switch r {
		case '/':
			if !inJsonStr && indexMultilineComment == -1 && indexInlineComment == -1 {
				// if currently not in a comment or json string, a slash
				// could be the beginning of a new comment. look ahead and see
				if len(json) > i+1 {
					if json[i+1] == '/' {
						indexInlineComment = i
						// since we already looked ahead, we don't need
						// to consider the next character
						skip = true
					} else if json[i+1] == '*' {
						indexMultilineComment = i
						// since we already looked ahead, we don't need
						// to consider the next character
						skip = true
					}
				}
			}
		case '*':
			if indexMultilineComment != -1 {
				// we are currently in a multiline comment. A star sign could mean
				// the end of our multiline comment. look ahead and see
				if len(json) > i+1 {
					if json[i+1] == '/' {
						indexMultilineComment = -1
						// since we already looked ahead, we don't need to consider
						// the next character
						skip = true
						// a bit nasty but since we don't want to print the current
						// character, we need to skip the rest
						continue
					}
				}
			}
		case '"':
			if inJsonStr {
				inJsonStr = false
			} else if !inJsonStr && indexMultilineComment == -1 && indexInlineComment == -1 {
				// if we are currently not in a comment, a quote sign can only mean
				// we got into a JSON string
				inJsonStr = true
			}
		case '\\':
			if len(json) > i+1 {
				if json[i+1] == '"' {
					// next quote sign is escaped and therefore looses it's meaning
					// as start/end of JSON string. put into output and skip both
					out.WriteRune('\\')
					out.WriteRune('"')
					skip = true
					continue
				} else if json[i+1] == '\\' {
					// the next escape must loose it's power to escape stuff
					// because it itself is escaped
					out.WriteRune('\\')
					skip = true
				}
			}
		case '\n':
			indexInlineComment = -1
		case '\r':
			indexInlineComment = -1
		}
		if indexMultilineComment == -1 && indexInlineComment == -1 {
			// only consider in output if character is outside of any comment
			if !stripSpace || inJsonStr || (r != '\n' && r != '\r' && r != '\t' && r != ' ') {
				// everything considered a whitespace (line feed, carriage return, tab, whitespace)
				// is only candidate for output if desired
				out.WriteRune(r)
			}
		}
	}
	return out.String()
}
