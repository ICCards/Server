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
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected",self,"_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	SyncManager.connect("sync_started",self,"_on_SyncManager_sync_started")
	SyncManager.connect("sync_stopped",self,"_on_SyncManager_sync_stopped")
	SyncManager.connect("sync_lost",self,"_on_SyncManager_sync_lost")
	SyncManager.connect("sync_regained",self,"_on_SyncManager_sync_regained")
	SyncManager.connect("sync_error",self,"_on_SyncManager_sync_error")
	
	var err = ws.listen(port,PoolStringArray(), true)
	print("Connecting...")
	if err != OK:
		print("Could not establish server connection.")
		set_process(false)
		return
	get_tree().network_peer = ws	
	print("Listing on port %d..." % port)

func _on_network_peer_connected(player_id):
	print(player_id+" Connected")
	SyncManager.add_peer(player_id)
	print("starting")
	yield(get_tree().create_timer(2.0),"timeout")
	SyncManager.start()

func _on_network_peer_disconnected(player_id):
	print(player_id+" Disconnected")
	SyncManager.remove_peer(player_id)
	
func _on_server_disconnected():
	_on_network_peer_disconnected(1)

func _on_SyncManager_sync_started():
	print("started")		
	
func _on_SyncManager_sync_stopped():
	pass	

func _on_SyncManager_sync_lost():
	print("sync lost")	
	
func _on_SyncManager_sync_regained():
	print("sync regained")

func _on_SyncManager_sync_error(msg):
	print("Fatal sync error: "+msg)			

func _process(_delta):
	if ws.is_listening():
		pass
	ws.poll()

#func _connected(player_id, proto):
#	print("Player: " + str(player_id) + " Connected")
#	var data = {"d":player_id}
#	var message = Util.toMessage("ID",data)
#	ws.get_peer(player_id).put_packet(message)
#
#func _close_request(player_id, code, reason):
#	# This is called when a client notifies that it wishes to close the connection,
#	# providing a reason string and close code.
#	print("Client %d disconnecting with code: %d, reason: %s" % [player_id, code, reason])
#
#func _disconnected(player_id, was_clean = false):
#	print("Player: " + str(player_id) + " Disconnected")
#	if world.has_node(str(player_id)):
#		world.get_node(str(player_id)).queue_free()
#		players.erase(player_id)
#		var data = {"d":player_id}
#		var message = Util.toMessage("DespawnPlayer",data)
#		for id in players.keys():
#			ws.get_peer(id).put_packet(message)

#func updateState(state):
#	var data = {"d":state}
#	var message = Util.toMessage("updateState",data)
#	for id in players.keys():
#		ws.get_peer(id).put_packet(message)
#
#func _spawnPlayer(data):
#	print("spawning")
#	print(data)
#	var value = {"d":data}
#	var message = Util.toMessage("SpawnPlayer",value)
#	ws.get_peer(data["id"]).put_packet(message)
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

#Client:
#
#var client = WebSocketClient.new();
#
#var url = "ws://127.0.0.1:" + str(PORT) # You use "ws://" at the beginning of the address for WebSocket connections
#
#var error = client.connect_to_url(url, PoolStringArray(), true);
#
#get_tree().set_network_peer(client);
