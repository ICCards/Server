extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

var player_state = {}
var world_state = {}

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
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	player_state.erase(player_id)
	if get_tree().get_root().has_node("World"):
		get_tree().get_root().get_node("World").delete_player(player_id)
	
		
func updateState(state):
	rpc_unreliable_id(0, "updateState", world_state)

remote func message_send(message):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state.has(player_id):
		if player_state_collection[player_id]["T"] < message["T"]:
			player_state_collection[player_id] = message
	else:
		player_state[player_id] = message

remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(),client_time)

remote func DetermineLatency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)
