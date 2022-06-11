extends Node

onready var Player = preload("res://World/Decorations/Player/Player.tscn")

var characters = ["human_male", "human_female", "lesser_demon_male", "ogre_female", "ogre_male", "water_draganoid_female", "water_draganoid_male", "seraphim_female", "seraphim_male", "goblin_male",  "goblin_female", "demi_wolf_male", "demi_wolf_female", "human_female", "lesser_demon_female", "lesser_spirit", "succubus"]

var network = NetworkedMultiplayerENet.new()
var port = 65124
var max_players = 100

var player_state = {}

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
	createPlayer(player_id)
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
		player_state.erase(player_id)
		rpc_id(0, "DespawnPlayer", player_id)
	
func createPlayer(player_id):
	var player = Player.instance()
	player.name = str(player_id)
	characters.shuffle()
	player.data["character"] = characters.front()
	add_child(player,true)
		
func updateState(state):
	rpc_unreliable_id(0, "updateState", state)

func _spawnPlayer():
	rpc_id(0,"SpawnPlayer")

remote func message_send(message):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state.has(player_id):
		if player_state[player_id]["T"] < message["T"]:
			player_state[player_id] = message
	else:
		player_state[player_id] = message

remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	print(client_time)
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(),client_time)

remote func DetermineLatency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	print(client_time)
	rpc_id(player_id, "ReturnLatency", client_time)
	
remote func GetCharacter():
	var player_id = get_tree().get_rpc_sender_id()
	var player = get_node(str(player_id))
	rpc_id(player_id, "ReceiveCharacter", player.data)
