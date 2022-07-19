extends Node

var world_state = {
	"players":{},
	"decorations":{},
	"day": true,
	"season": "Spring",
	"day_num": 1,
	"time_elapsed":0
}

func _physics_process(_delta):
	world_state["day"] = Server.day
	world_state["season"] = Server.season
	world_state["day_num"] = Server.day_num
	world_state["time_elapsed"] = Server.time_elapsed
	if not Server.players.empty():
		world_state["decorations"] = Server.decorations.duplicate(true)
		world_state["players"] = Server.players.duplicate(true)
		for player in world_state["players"].keys():
			world_state["players"][player].erase("t")
		world_state["t"] = OS.get_system_time_msecs()
		# Anti-cheat stuff and physics check here
		#Server.updateState(world_state)
