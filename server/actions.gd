extends Node

func action(player_id,message):
	match message["n"]:
		("MOVEMENT"):
			print(Server.players[player_id])
			if Server.players[player_id]["t"] < message["d"]["t"]:
				Server.players[player_id]["p"] = message["d"]["p"]
				Server.players[player_id]["d"] = message["d"]["d"]
		("SWING"):
			pass
		("ON_HIT"):
			onHit(message)
		("PLACE_ITEM"):
			var id = message["d"]["id"]
			var object_type = message["d"]["t"]
			Server.world.map["decorations"][object_type][id] = message["d"]
			print("place item " + id)
			print(message["d"])
		("CHANGE_TILE"):
			pass
#			var name = data["n"]
#			var id = data["id"]
#			var loc = data["l"]
#			if name == "hoe" or name == "water":
#				Server.world.map["tile"][id] = {"n": name, "l": loc}
#			elif name == "remove":
#				for _id in Server.world.map["tile"]:
#					if Server.world.map["tile"][_id]["l"] == loc:
#						Server.world.map["tile"].erase(_id)
	return message

func onHit(data):
	if not data.empty():
		var name = data["n"]
		var id = data["d"]["id"]
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
				var object_type = data["d"]["t"]
				Server.world.map["decorations"][object_type].erase(id)
				print("erasing object from world " + str(id))
