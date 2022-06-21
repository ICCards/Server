extends Node

func getMessage(data):
	var res = JSON.parse(data.get_string_from_utf8())
	var obj = res.result
	#typeof(obj)
