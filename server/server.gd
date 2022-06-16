extends Node

var world
var network = NetworkedMultiplayerENet.new()
var port = 65124
var max_players = 100
var decoration_state = {}
var players = {}
var message
func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	network.connect("peer_connected", self, "_player_connected")
	network.connect("peer_disconnected", self, "_player_disconnected")
	
	print("Server Started")
	
func _player_connected(player_id):
	print("Player: " + str(player_id) + " Connected")
	if not players.keys().has(player_id):
		world.spawnPlayer(player_id)
	rpc_unreliable_id(player_id, "loadMap", world.map)
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	if world.has_node(str(player_id)):
		world.get_node(str(player_id)).queue_free()
		players.erase(player_id)
		rpc_unreliable_id(0, "DespawnPlayer", player_id)
	
func updateState(state):
	rpc_unreliable_id(0, "updateState", state)

#remote func getMap():
#	var player_id = get_tree().get_rpc_sender_id()
	#rpc_unreliable_id(player_id, "loadMap", world.map)

#func _spawnPlayer(data):
#	print("spawning")
#	print(data)
#	rpc_unreliable_id(data["id"],"SpawnPlayer",data)

remote func message_send(value):
	message = value

#remote func message_send(message):
#	print(message)
#	var player_id = get_tree().get_rpc_sender_id()
#	if players.has(player_id):
#		if players[player_id]["T"] < message["T"]:
#			players[player_id] = message
#	else:
#		players[player_id] = message

remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(),client_time)

remote func DetermineLatency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)
	
remote func GetCharacter():
	var player_id = get_tree().get_rpc_sender_id()
	var player = world.get_node(str(player_id))
	rpc_id(player_id, "ReceiveCharacter", player.data,player_id)

#remote func GetCharacterById(player_id):
#	var caller = get_tree().get_rpc_sender_id()
#	var player = world.get_node(str(player_id))
#	rpc_id(caller, "ReceiveCharacter", player.data,player_id)

remote func action(type,data):
	var player_id = get_tree().get_rpc_sender_id()
	if players.keys().has(player_id):
		if players[player_id]["t"] < data["t"]:
			players[player_id]["p"] = data["p"]
			players[player_id]["d"] = data["d"]
#			match type:
#				("MOVEMENT"):
#					pass
#					#var player = world.get_node(str(player_id))
#
#				("SWING"):
#					pass
	else:
		players[player_id] = data
#		match type:
#			("MOVEMENT"):
#				pass
#			("SWING"):
#				pass
	#rpc_id(0, "ReceivedAction",client_clock,player_id,input)
