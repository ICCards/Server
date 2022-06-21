extends Node

func action(player_id,message):
	var data = message["d"]
	match message["t"]:
		("MOVEMENT"):
			if Server.players[player_id]["t"] < data["t"]:
				Server.players[player_id]["p"] = data["p"]
				Server.players[player_id]["d"] = data["d"]
		("SWING"):
			pass
		("ON_HIT"):
			onHit(data)
		("PLACE_ITEM"):
			var id = data["id"]
			var object_type = data["t"]
			Server.world.map["decorations"][object_type][id] = data
			print("place item " + id)
		("CHANGE_TILE"):
			var name = data["n"]
			var id = data["id"]
			var loc = data["l"]
			if name == "hoe" or name == "water":
				Server.world.map["tile"][id] = {"n": name, "l": loc}
			elif name == "remove":
				for _id in Server.world.map["tile"]:
					if Server.world.map["tile"][_id]["l"] == loc:
						Server.world.map["tile"].erase(_id)
	return data

func onHit(data):
	if not data.empty():
		var name = data["n"]
		var id = data["id"]
		match name:
			("dirt"):
				pass
			("grass"):
				pass
			("dark_grass"):
				pass
			("tall_grass"):
				pass
			("water"):
				pass
			("tree"):
				print("tree Id")
				print(id)
				Server.world.map[name][id]["h"] - 1
				if Server.world.map[name][id]["h"] - 1 <= 0:
					Server.world.map[name].erase(id)
			("ore_large"):
				Server.world.map[name][id]["h"] - 1
				if Server.world.map[name][id]["h"] - 1 <= 0:
					Server.world.map[name].erase(id)
			("ore"):
				Server.world.map[name][id]["h"] - 1
				if Server.world.map[name][id]["h"] - 1 <= 0:
					Server.world.map[name].erase(id)
			("log"):
				Server.world.map[name][id]["h"] - 1
				if Server.world.map[name][id]["h"] - 1 <= 0:
					Server.world.map[name].erase(id)
			("stump"):
				Server.world.map[name][id]["h"] - 1
				if Server.world.map[name][id]["h"] - 1 <= 0:
					Server.world.map[name].erase(id)
			("flower"):
				pass
			("decorations"):
				var object_type = data["t"]
				Server.world.map["decorations"][object_type].erase(id)
				print("erasing object from world " + str(id))
