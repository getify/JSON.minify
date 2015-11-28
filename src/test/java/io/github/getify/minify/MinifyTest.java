package io.github.getify.minify;

import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by nfischer on 11/28/15.
 */
public class MinifyTest {

    @Test
    public void testBasicComments(){
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
        Assert.assertEquals(test1_res, Minify.minify(test1));
    }

    @Test
    public void testCommentTokensInField(){
        System.out.println("Running test2...");
        String test2 = "{\"/*\":\"*/\",\"//\":\"\",/*\"//\"*/\"/*/\"://\n" +
                "\"//\"}" +
                "";

        String test2_res = "{\"/*\":\"*/\",\"//\":\"\",\"/*/\":\"//\"}";
        Assert.assertEquals(test2_res, Minify.minify(test2));
    }

    @Test
    public void testMultilineComment(){
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
        Assert.assertEquals(test3_res, Minify.minify(test3));
    }

    @Test
    public void testEscapeSequences(){
        System.out.println("Running test4...");
        String test4 = "{\"foo\": \"ba\\\"r//\", \"bar\\\\\": \"b\\\\\\\"a/*z\", \n" +
                "\"baz\\\\\\\\\": /*  yay */ \"fo\\\\\\\\\\\"*/o\"\n" +
                "}";
        String test4_res = "{\"foo\":\"ba\\\"r//\",\"bar\\\\\":\"b\\\\\\\"a/*z\",\"baz\\\\\\\\\":\"fo\\\\\\\\\\\"*/o\"}";
        Assert.assertEquals(test4_res, Minify.minify(test4));
    }

    @Test
    public void test5(){
        System.out.println("Running test5...");
        String test5 =  "// this is a comment //\n" +
                "{ // another comment\n" +
                "   true, \"foo\", // 3rd comment\n" +
                "   \"http://www.ariba.com\" // comment after URL\n" +
                "   \n" +
                "}";
        String test5_res = "{true,\"foo\",\"http://www.ariba.com\"}";
        Assert.assertEquals(test5_res, Minify.minify(test5));
    }

    @Test
    public void testNullInput(){
        try {
            Minify.minify(null);
        }catch (IllegalArgumentException e){
            return;
        }
        fail("Should have thrown exception");
    }

}