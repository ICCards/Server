extends Node

var world_state = {}

func _physics_process(delta):
	if not get_parent().player_state.empty():
		world_state = get_parent().player_state.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		
		# Anti-cheat stuff and physics check here
		# Cuts (chunking / maps)
		get_parent().updateState(world_state)
