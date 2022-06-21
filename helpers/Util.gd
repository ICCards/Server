extends Node


func jsonParse(body):
  var stringResult: String = body.get_string_from_utf8()
  var jsonParseResult: JSONParseResult = JSON.parse(stringResult)
  return jsonParseResult.result

func toMessage(name, data):
	var response = {"n":name,"d":data}
	return JSON.print(response).to_utf8()
