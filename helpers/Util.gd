extends Node


func jsonParse(body):
  var stringResult: String = body.get_string_from_utf8()
  var jsonParseResult: JSONParseResult = JSON.parse(stringResult)
  return jsonParseResult.result

func toMessage(name, data):
	if name == "loadMap":
		var mapData = {"d":data,"n":name}
		return JSON.print(mapData).to_utf8()
	else:	
		data["n"] = name
		return JSON.print(data).to_utf8()
