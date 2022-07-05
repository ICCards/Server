extends Node


func jsonParse(body):
  var stringResult: String = body.get_string_from_utf8()
  var jsonParseResult: JSONParseResult = JSON.parse(stringResult)
  return jsonParseResult.result

func toMessage(name, data):
	data["n"] = name
	return JSON.print(data).to_utf8()
		
