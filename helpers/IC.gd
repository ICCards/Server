extends Node

var this = self
var url = "https://nheqc-cqaaa-aaaan-qam6a-cai.raw.ic0.app"
var endpoint = "player"
var rng = RandomNumberGenerator.new()
var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)

func principal(player_id):
	rng.randomize()
	var random_delay = rng.randf_range(0.1, 0.9)
	yield(get_tree().create_timer(random_delay), "timeout")
	http_request.connect("request_completed", this, "_principal_request_completed")
	http_request.request(url+"/"+endpoint+"/"+str(player_id))

func _principal_request_completed(result, response_code, headers, body):
	print("response_code")
	print(response_code)
	if response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8()).result
		print(json)
		if not json.keys().empty():
			var key = json.keys()[0]
			print(key)
			if Server.players.has(key):
				print("got principal")
				print(json[key])
				Server.players[key]["principal"] = json[key]
