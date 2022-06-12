extends Node

var world_state = {}

func _physics_process(delta):
	if not Server.player_state.empty():
		world_state = Server.player_state.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		# Anti-cheat stuff and physics check here
		Server.updateState(world_state)
