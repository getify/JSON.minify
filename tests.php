<?php

require_once("./minify.json.php");

$tests = array(
	array(
		"source" => "
			// this is a JSON file with comments
			{
				\"foo\": \"bar\",	// this is cool
				\"bar\": [
					\"baz\", \"bum\", \"zam\"
				],
			/* the rest of this document is just fluff
			   in case you are interested. */
				\"something\": 10,
				\"else\": 20
			}

			/* NOTE: You can easily strip the whitespace and comments
			   from such a file with the JSON.minify() project hosted
			   here on github at http://github.com/getify/JSON.minify
			*/\n",
		"assert" => "{\"foo\":\"bar\",\"bar\":[\"baz\",\"bum\",\"zam\"],\"something\":10,\"else\":20}"
	),
	array(
		"source" => "
			\n
			{\"/*\":\"*/\",\"//\":\"\",/*\"//\"*/\"/*/\"://
			\"//\"}
			\n",
		"assert" => "{\"/*\":\"*/\",\"//\":\"\",\"/*/\":\"//\"}"
	),
	array(
		"source" => "
			/*
			this is a
			multi line comment */{
			\n
			\"foo\"
			:
				\"bar/*\"// something
				,	\"b\\\"az\":/*
			something else */\"blah\"
			\n
			}\n",
		"assert" => "{\"foo\":\"bar/*\",\"b\\\"az\":\"blah\"}"
	),
	array(
		"source" => "
			{\"foo\": \"ba\\\"r//\", \"bar\\\\\": \"b\\\\\\\"a/*z\",
				\"baz\\\\\\\\\": /* yay */ \"fo\\\\\\\\\\\"*/o\"
			}\n",
		"assert" => "{\"foo\":\"ba\\\"r//\",\"bar\\\\\":\"b\\\\\\\"a/*z\",\"baz\\\\\\\\\":\"fo\\\\\\\\\\\"*/o\"}"
	)
);

foreach ($tests as $idx => $test) {
	$res = json_minify($test["source"]);
	if ($test["assert"] !== $res) {
		throw new Exception("Test (" . ($idx + 1) . ") failed:\n  " . $res);
	}
	echo "Test " . ($idx + 1) . " passed\n";
}

echo "Done.\n";

?>