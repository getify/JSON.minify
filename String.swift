//
//  String.swift
//  JSON.minify
//
//  Created by Tibor Bodecs on 17/01/15.
//  Copyright (c) 2015 Tibor Bodecs. All rights reserved.
//

import Foundation

extension String
{

    func minifyJSONString() -> String {

        let _self                 = self as NSString
        var in_string             = false
        var in_multiline_comment  = false
        var in_singleline_comment = false
        var tmp : NSString        = ""
        var tmp2 : NSString       = ""
        var new_str : [NSString]  = []
        var from                  = 0
        var lc : NSString         = ""
        var rc : NSString         = ""
        var lastIndex             = 0

        let tokenizer = NSRegularExpression(pattern: "\"|(\\/\\*)|(\\*\\/)|(\\/\\/)|\n|\r", options: .CaseInsensitive, error: nil)!
        let magic     = NSRegularExpression(pattern: "(\\\\)*$", options: .CaseInsensitive, error: nil)!
        let matches   = tokenizer.matchesInString(_self, options: NSMatchingOptions(0), range: NSMakeRange(0, _self.length)) as [NSTextCheckingResult]

        if matches.count == 0 {
            return self
        }

        for match in matches {
            let range = match.range
            tmp       = _self.substringWithRange(range)
            lastIndex = range.location + range.length
            lc        = _self.substringWithRange(NSMakeRange(0, range.location))
            rc        = _self.substringWithRange(NSMakeRange(lastIndex, _self.length-lastIndex))

            if !in_multiline_comment && !in_singleline_comment {
                tmp2 = lc.substringWithRange(NSMakeRange(from, lc.length-from))
                if !in_string {
                    let words = tmp2.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as [String]
                    tmp2 = "".join(words)
                }
                new_str.append(tmp2)
            }
            from = lastIndex

            if tmp.hasPrefix("\"") && !in_multiline_comment && !in_singleline_comment {
                let _matches = magic.matchesInString(lc, options: NSMatchingOptions(0), range: NSMakeRange(0, lc.length))
                if _matches.count > 0 {
                    let _match: NSTextCheckingResult = _matches.first! as NSTextCheckingResult
                    let _range = _match.range
                    if !in_string || _range.length%2 == 0 {
                        in_string = !in_string
                    }
                }
                from--
                rc = _self.substringWithRange(NSMakeRange(from, _self.length-from))
            }
            else if tmp.hasPrefix("/*") && !in_string && !in_multiline_comment && !in_singleline_comment {
                in_multiline_comment = true
            }
            else if tmp.hasPrefix("*/") && !in_string && in_multiline_comment && !in_singleline_comment {
                in_multiline_comment = false
            }
            else if tmp.hasPrefix("//") && !in_string && !in_multiline_comment && !in_singleline_comment {
                in_singleline_comment = true
            }
            else if (tmp.hasPrefix("\n") || tmp.hasPrefix("\r")) && !in_string && !in_multiline_comment && in_singleline_comment {
                in_singleline_comment = false
            }
            else if !in_multiline_comment && !in_singleline_comment {
                let words = tmp.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
                tmp = "".join(words)
                if tmp.length > 0 {
                    new_str.append(tmp)
                }
            }
        }
        new_str.append(rc)

        return "".join(new_str as [String])
    }

}
