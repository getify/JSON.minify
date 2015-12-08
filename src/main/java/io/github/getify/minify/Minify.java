//
//  Minify.java
//  jsonminifier - Ported from https://github.com/getify/JSON.minify
//
//  Created by Bernhard Gass on 8/01/13.
//  Copyright © 2013 Bernhard Gass. All rights reserved.

package io.github.getify.minify;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 */
public abstract class Minify {

    private static final String TOKENIZER = "\"|(/\\*)|(\\*/)|(//)|\\n|\\r";
    private static final String MAGIC = "(\\\\)*$";
    private static final Pattern PATTERN = Pattern.compile(TOKENIZER);
    private static final Pattern MAGIC_PATTERN = Pattern.compile(MAGIC);

    /**
     *
     * @param json a json object with comments
     * @return a compact json object with comments stripped out
     */
    public static String minify(CharSequence json) {
        if(json == null)
            throw new IllegalArgumentException("Parameter 'json' cannot be null.");

        String jsonString = json.toString();

        Boolean in_string = false;
        Boolean in_multiline_comment = false;
        Boolean in_singleline_comment = false;
        String tmp;
        String tmp2;
        StringBuilder new_str = new StringBuilder();
        Integer from = 0;
        String lc;
        String rc = "";

        Matcher matcher = PATTERN.matcher(jsonString);

        Matcher magicMatcher;
        Boolean foundMagic;

        if (!matcher.find())
            return jsonString;
        else
            matcher.reset();

        while (matcher.find()) {
            lc = jsonString.substring(0, matcher.start());
            rc = jsonString.substring(matcher.end(), jsonString.length());
            tmp = jsonString.substring(matcher.start(), matcher.end());

            if (!in_multiline_comment && !in_singleline_comment) {
                tmp2 = lc.substring(from);
                if (!in_string)
                    tmp2 = tmp2.replaceAll("(\\n|\\r|\\s)*", "");

                new_str.append(tmp2);
            }
            from = matcher.end();

            if (tmp.charAt(0) == '\"' && !in_multiline_comment && !in_singleline_comment) {
                magicMatcher = MAGIC_PATTERN.matcher(lc);
                foundMagic = magicMatcher.find();
                if (!in_string || !foundMagic || (magicMatcher.end() - magicMatcher.start()) % 2 == 0) {
                    in_string = !in_string;
                }
                from--;
                rc = jsonString.substring(from);
            }
            else
            if (tmp.startsWith("/*") && !in_string && !in_multiline_comment && !in_singleline_comment) {
                in_multiline_comment = true;
            }
            else
            if (tmp.startsWith("*/") && !in_string && in_multiline_comment) {
                in_multiline_comment = false;
            }
            else
            if (tmp.startsWith("//") && !in_string && !in_multiline_comment && !in_singleline_comment) {
                in_singleline_comment = true;
            }
            else
            if ((tmp.startsWith("\n") || tmp.startsWith("\r")) && !in_string && !in_multiline_comment && in_singleline_comment) {
                in_singleline_comment = false;
            }
            else
            if (!in_multiline_comment && !in_singleline_comment && !tmp.substring(0, 1).matches("\\n|\\r|\\s")) {
                    new_str.append(tmp);
            }
        }
        new_str.append(rc);

        return new_str.toString();
    }

}
