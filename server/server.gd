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
var delta
var input_data = null

const LOG_FILE_DIRECTORY = 'user://detailed_logs'

var logging_enabled := true


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected",self,"_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	
	var err = ws.listen(port,PoolStringArray(), true)
	print("Connecting...")
	if err != OK:
		print("Could not establish server connection.")
		set_process(false)
		return
	get_tree().network_peer = ws	
	print("Listing on port %d..." % port)

func _on_network_peer_connected(player_id):
	pass
#	SyncManager.add_peer(player_id)
#	if get_tree().is_network_server():
#		print("Starting...")
#		# Give a little time to get ping data.
#		yield(get_tree().create_timer(2.0), "timeout")
#		SyncManager.start()


func _on_network_peer_disconnected(player_id):
	print(str(player_id)+" Disconnected")
	
func _on_server_disconnected():
	_on_network_peer_disconnected(1)

func _process(_delta):
	if ws.is_listening():
		pass
	ws.poll()
	
remote func move(id,position,direction):
	var player = world.Players.get_node(id)
	player.move(position,direction)

remote func input(data):
	var player_id = get_tree().get_rpc_sender_id()
	var player = world.Players.get_node(str(player_id))
	player.thr_network_inputs(data)
		
remote func login():
	var player_id = get_tree().get_rpc_sender_id()
	if not players.keys().has(player_id):
		IC.principal(player_id)

remote func login_test():
	var player_id = get_tree().get_rpc_sender_id()
	if not players.keys().has(player_id):
		world.spawnPlayer(player_id,"j26ec-ix7zw-kiwcx-ixw6w-72irq-zsbyr-4t7fk-alils-u33an-kh6rk-7qe")		

remote func get_map(key):
	var player_id = get_tree().get_rpc_sender_id()
	var value = world.map[key]
	rpc_id(player_id, "load_map",value)
	
remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(),client_time)

remote func DetermineLatency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)

func updateState(state):
	rpc_id(0, "updateState",state)

func _spawnPlayer(data):
	print("spawning")
	print(data)
	rpc_id(0, "spawn_player",data)
#
#func _on_data(player_id):
#	var pkt = ws.get_peer(player_id).get_packet()
#	var message = Message.new()
#	message.fromJson(pkt)
#	var result = Util.jsonParse(pkt)
#	var time = OS.get_system_time_msecs()
#	match message.message_name:
#		("LOGIN"):
#			if not players.keys().has(player_id):
#				IC.principal(player_id)
#		("SEND_MESSAGE"):
#			var responses = {"t":time,"id":player_id,"d": message.data}
#			var value = Util.toMessage("ReceiveMessage",responses)
#			for player_id in players.keys():
#				ws.get_peer(player_id).put_packet(value)
#		("getMap"):
#			var data = {"d":world.map[message.data]}
#			var value = Util.toMessage("loadMap",data)
#			ws.get_peer(player_id).put_packet(value)
#		("FetchServerTime"):
#			var data = {"s":OS.get_system_time_msecs(),"c":message.data, "delta":delta}
#			var response = {"d":data}
#			var value = Util.toMessage("ReturnServerTime",response)
#			ws.get_peer(player_id).put_packet(value)
#		("DetermineLatency"):
#			var data = {"d":message.data}
#			var value = Util.toMessage("ReturnLatency",data)
#			ws.get_peer(player_id).put_packet(value)
#		("action"):
#			Actions.action(player_id,result)

