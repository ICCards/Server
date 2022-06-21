extends Node

var port = 65124
var counter = 0
var ws = WebSocketServer.new()
var decoration_state = {}
var players = {}
var world
# Called when the node enters the scene tree for the first time.
func _ready():
	ws.connect("client_connected",self,"_connected")
	ws.connect("client_disconnected", self, "_disconnected")
	ws.connect("data_received", self, "_on_data")
	ws.connect("client_close_request", self, "_close_request")
	var err = ws.listen(port)
	print("Connecting...")
	if err != OK:
		print("Could not establish server connection.")
		set_process(false)
		return
	print("Listing on port %d..." % port)
	
func _connected(player_id, proto):
	print("Player: " + str(player_id) + " Connected")
	var message = Util.toMessage("ID",player_id)
	ws.get_peer(player_id).put_packet(message)
	if not players.keys().has(player_id):
		world.spawnPlayer(player_id)

func _close_request(player_id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [player_id, code, reason])

func _disconnected(player_id, was_clean = false):
	print("Player: " + str(player_id) + " Disconnected")
	if world.has_node(str(player_id)):
		world.get_node(str(player_id)).queue_free()
		players.erase(player_id)
		var message = Util.toMessage("DespawnPlayer",player_id)
		for id in players.keys():
			ws.get_peer(id).put_packet(message)

func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	ws.poll()

func updateState(state):
	var message = Util.toMessage("updateState",state)
	for id in players.keys():
		ws.get_peer(id).put_packet(message)
	
func _spawnPlayer(data):
	print("spawning")
	print(data)
	var message = Util.toMessage("SpawnPlayer",data)
	ws.get_peer(data["id"]).put_packet(message)

func _on_data(player_id):
	var pkt = ws.get_peer(player_id).get_packet()
	var result = Util.jsonParse(pkt)
	var time = OS.get_system_time_msecs()
	var responses = {"t":time,"id":player_id,"m":result}
	match result["n"]:
		("getMap"):
			for tileType in world.map.keys():
				for id in world.map[tileType].keys():
					var data = {"d":world.map[tileType][id],"t":tileType,"id":id}
					#print("sending data")
					#print(data)
					var message = Util.toMessage("loadMap",data)
					ws.get_peer(player_id).put_packet(message)
			var message = Util.toMessage("MapLoaded","")
			ws.get_peer(player_id).put_packet(message)
#			var key = result["d"]
#			print("got " + str(key))
#			if key < world.map.size():
#				for tileType in world.map.keys():
#					if world.map[tileType].has(key):
#						var data = {"d":world.map[tileType][key],"t":tileType}
#						print("sending data")
#						print(data)
#						var message = Util.toMessage("loadMap",data)
#						ws.get_peer(player_id).put_packet(message)
#						break
#			else:
#				var message = Util.toMessage("MapLoaded","")
#				ws.get_peer(player_id).put_packet(message)
		("FetchServerTime"):
			var client_time = result["d"]
			var data = {"s":OS.get_system_time_msecs(),"c":client_time}
			var message = Util.toMessage("ReturnServerTime",data)
			ws.get_peer(player_id).put_packet(message)
		("DetermineLatency"):
			var client_time = result["d"]
			var message = Util.toMessage("ReturnLatency",client_time)
			ws.get_peer(player_id).put_packet(message)
		("action"):
			Actions.action(player_id,result)
			var message = Util.toMessage("ReceivedAction", responses)
			for id in players.keys():
				ws.get_peer(id).put_packet(message)
	#print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	#ws.get_peer(id).put_packet(pkt)
