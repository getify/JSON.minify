test("Json.minify", function() {
	expect(4);
	var old;
	for (var i=1; i<=4; i++) {
		old = document.getElementById("orig_json"+i).value;
		document.getElementById("new_json"+i).value = JSON.minify(old);
	}
	same(document.getElementById('new_json1').value, '{\"foo\":\"bar\",\"bar\":[\"baz\",\"bum\",\"zam\"],\"something\":10,\"else\":20}', 'test 1');
	same(document.getElementById('new_json2').value, '{\"/*\":\"*/\",\"//\":\"\",\"/*/\":\"//\"}', 'test 2');
	same(document.getElementById('new_json3').value, '{"foo":"bar/*","b\\"az":"blah"}', 'test 3');
	same(document.getElementById("new_json4").value, '{"foo":"ba\\"r//","bar\\\\":"b\\\\\\\"a/*z","baz\\\\\\\\":"fo\\\\\\\\\\\"*/o"}', 'test 4');
});
