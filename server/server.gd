extends Node


var world


var network = NetworkedMultiplayerENet.new()
var port = 65124
var max_players = 100

var player_state = {}
var decoration_state = {}

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
	world.spawnPlayer(player_id)
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	if world.has_node(str(player_id)):
		world.get_node(str(player_id)).queue_free()
		player_state.erase(player_id)
		rpc_id(0, "DespawnPlayer", player_id)
	
		
func updateState(state):
	rpc_unreliable_id(0, "updateState", state)

remote func message_send(message):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state.has(player_id):
		if player_state[player_id]["T"] < message["T"]:
			player_state[player_id] = message
	else:
		player_state[player_id] = message

func _spawnPlayer(player_id,location):
	rpc_id(0,"SpawnPlayer",player_id,location)

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

remote func GetCharacterById(player_id):
	var caller = get_tree().get_rpc_sender_id()
	var player = world.get_node(str(player_id))
	rpc_id(caller, "ReceiveCharacter", player.data,player_id)

remote func action(input, client_clock):

	var player_id = get_tree().get_rpc_sender_id()
	var player = world.get_node(player_id)
	match (input):
		("mouse_click"):
			player.swing()
	rpc_id(0, "ReceivedAction",client_clock,player_id,input)