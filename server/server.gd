extends Node

var port = 65124
var counter = 0
var ws = WebSocketServer.new()
var decorations = {"seed":{},"placable":{}}
var players = {}
var world
var day = true
var day_num = 1
var season = "Spring"
var time_elapsed = 0
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
	var data = {"d":player_id}
	var message = Util.toMessage("ID",data)
	ws.get_peer(player_id).put_packet(message)
	
func _close_request(player_id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [player_id, code, reason])

func _disconnected(player_id, was_clean = false):
	print("Player: " + str(player_id) + " Disconnected")
	if world.has_node(str(player_id)):
		world.get_node(str(player_id)).queue_free()
		players.erase(player_id)
		var data = {"d":player_id}
		var message = Util.toMessage("DespawnPlayer",data)
		for id in players.keys():
			ws.get_peer(id).put_packet(message)

func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	ws.poll()

func updateState(state):
	var data = {"d":state}
	var message = Util.toMessage("updateState",data)
	for id in players.keys():
		ws.get_peer(id).put_packet(message)
	
func _spawnPlayer(data):
	print("spawning")
	print(data)
	var value = {"d":data}
	var message = Util.toMessage("SpawnPlayer",value)
	ws.get_peer(data["id"]).put_packet(message)

func _on_data(player_id):
	var pkt = ws.get_peer(player_id).get_packet()
	var message = Message.new()
	message.fromJson(pkt)
	var result = Util.jsonParse(pkt)
	var time = OS.get_system_time_msecs()
	match result["n"]:
		("LOGIN"):
			if not players.keys().has(player_id):
				IC.principal(player_id)
		("SEND_MESSAGE"):
			var responses = {"t":time,"id":player_id,"d": message.data}
			var value = Util.toMessage("ReceiveMessage",responses)
			for player_id in players.keys():
				ws.get_peer(player_id).put_packet(value)
		("getMap"):
			var data = {"d":message.data}
			var value = Util.toMessage("loadMap",world.map[data])
			ws.get_peer(player_id).put_packet(message)
		("FetchServerTime"):
			var data = {"s":OS.get_system_time_msecs(),"c":message.data}
			var response = {"d":data}
			var value = Util.toMessage("ReturnServerTime",response)
			ws.get_peer(player_id).put_packet(message)
		("DetermineLatency"):
			var data = {"d":message.data}
			var value = Util.toMessage("ReturnLatency",data)
			ws.get_peer(player_id).put_packet(value)
		("action"):
			Actions.action(player_id,result)
