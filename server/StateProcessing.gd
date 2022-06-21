extends Node

var world_state = {
	"players":{},
	"decoration_state":{},
	"day": true,
	"season": "Spring",
	"day_num": 1,
}

func _physics_process(_delta):
	world_state["day"] = Server.day
	world_state["season"] = Server.season
	world_state["day_num"] = Server.day_num
	if not Server.players.empty():
		#world_state["decoration_state"] = Server.decoration_state.duplicate(true)
		world_state["players"] = Server.players.duplicate(true)
		for player in world_state["players"].keys():
			world_state["players"][player].erase("t")
		world_state["t"] = OS.get_system_time_msecs()
		# Anti-cheat stuff and physics check here
		Server.updateState(world_state)
