extends Node

var world_state = {
	"player_state":{},
	"decoration_state":{}
}

func _physics_process(_delta):
	if not Server.player_state.empty() or not Server.decoration_state.empty():
		world_state["player_state"] = Server.player_state.duplicate(true)
		world_state["decoration_state"] = Server.decoration_state.duplicate(true)
		for player in world_state["player_state"].keys():
			world_state["player_state"][player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		# Anti-cheat stuff and physics check here
		Server.updateState(world_state)
