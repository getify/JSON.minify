//
//  Minify.java
//  jsonminifier - Ported from https://github.com/getify/JSON.minify
//
//  Created by Bernhard Gass on 8/01/13.
//  Copyright © 2013 Bernhard Gass. All rights reserved.

package com.changeme.json;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.Test;

public class Minify {

    public String minify(String jsonString) {
        String tokenizer = "\"|(/\\*)|(\\*/)|(//)|\\n|\\r";
        String magic = "(\\\\)*$";
        Boolean in_string = false;
        Boolean in_multiline_comment = false;
        Boolean in_singleline_comment = false;
        String tmp = "";
        String tmp2 = "";
        List<String> new_str = new ArrayList<String>();
        Integer from = 0;
        String lc = "";
        String rc = "";

        Pattern pattern = Pattern.compile(tokenizer);
        Matcher matcher = pattern.matcher(jsonString);

        Pattern magicPattern = Pattern.compile(magic);
        Matcher magicMatcher = null;
        Boolean foundMagic = false;

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

                new_str.add(tmp2);
            }
            from = matcher.end();

            if (tmp.charAt(0) == '\"' && !in_multiline_comment && !in_singleline_comment) {
                magicMatcher = magicPattern.matcher(lc);
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
            if (tmp.startsWith("*/") && !in_string && in_multiline_comment && !in_singleline_comment) {
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
                    new_str.add(tmp);
            }
        }

        new_str.add(rc);
        StringBuffer sb = new StringBuffer();
        for (String str : new_str)
            sb.append(str);

        return sb.toString();
    }

    @Test
    public void testMinify() {
        System.out.println("!! Assertions will only be executed if the -ea vm argument is set !!");

        System.out.println("Running test1...");
        String test1 = "// this is a JSON file with comments\n" +
                "{\n" +
                "\"foo\": \"bar\",    // this is cool\n" +
                "\"bar\": [\n" +
                "\"baz\", \"bum\", \"zam\"\n" +
                "],\n" +
                "/* the rest of this document is just fluff\n" +
                "in case you are interested. */\n" +
                "\"something\": 10,\n" +
                "\"else\": 20\n" +
                "}\n" +
                "/* NOTE: You can easily strip the whitespace and comments\n" +
                "   from such a file with the JSON.minify() project hosted \n"+
                "   here on github at http://github.com/getify/JSON.minify \n"+
                "*/";

        String test1_res = "{\"foo\":\"bar\",\"bar\":[\"baz\",\"bum\",\"zam\"],\"something\":10,\"else\":20}";
        assert(minify(test1).equals(test1_res));

        System.out.println("Running test2...");
        String test2 = "{\"/*\":\"*/\",\"//\":\"\",/*\"//\"*/\"/*/\"://\n" +
                      "\"//\"}" +
                      "";

        String test2_res = "{\"/*\":\"*/\",\"//\":\"\",\"/*/\":\"//\"}";
        assert(minify(test2).equals(test2_res));

        System.out.println("Running test3...");
        String test3 =  "/*\n" +
                        "this is a\n" +
                        "multi line comment */{\n" +
                        "\n" +
                        "\"foo\"\n" +
                        ":" +
                        "    \"bar/*\"// something\n" +
                        "    ,    \"b\\\"az\":/*\n" +
                        "something else */\"blah\"\n" +
                        "\n" +
                        "}";

        String test3_res = "{\"foo\":\"bar/*\",\"b\\\"az\":\"blah\"}";
        assert(minify(test3).equals(test3_res));

        System.out.println("Running test4...");
        String test4 = "{\"foo\": \"ba\\\"r//\", \"bar\\\\\": \"b\\\\\\\"a/*z\", \n" +
                      "\"baz\\\\\\\\\": /*  yay */ \"fo\\\\\\\\\\\"*/o\"\n" +
                        "}";
        String test4_res = "{\"foo\":\"ba\\\"r//\",\"bar\\\\\":\"b\\\\\\\"a/*z\",\"baz\\\\\\\\\":\"fo\\\\\\\\\\\"*/o\"}";
        assert(minify(test4).equals(test4_res));

        System.out.println("Running test5...");
        String test5 =  "// this is a comment //\n" +
                "{ // another comment\n" +
                "   true, \"foo\", // 3rd comment\n" +
                "   \"http://www.ariba.com\" // comment after URL\n" +
                "   \n" +
                "}";
        String test5_res = "{true,\"foo\",\"http://www.ariba.com\"}";
        assert(minify(test5).equals(test5_res));
        System.out.println(test5);
        System.out.println(minify(test5));
    }
}
