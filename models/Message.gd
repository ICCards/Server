extends Node

class_name Message

var data
var message_name

func fromJson(value):
	var result = Util.jsonParse(value)
	data = result["d"]
	message_name = result["n"]
