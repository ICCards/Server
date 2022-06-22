extends Node

func action(player_id,message):
	match message["t"]:
		("MOVEMENT"):
			if Server.players[player_id]["t"] < message["d"]["t"]:
				Server.players[player_id]["p"] = message["d"]["p"]
				Server.players[player_id]["d"] = message["d"]["d"]
		("SWING"):
			pass
		("ON_HIT"):
			onHit(message)
		("PLACE_ITEM"):
			print(message)
			var id = message["d"]["id"]
			var object_type = message["d"]["t"]
			Server.decorations[object_type][id] = message["d"]
			print("place item " + id)
			print(message["d"])
		("HOE"):
			var id = message["d"]["id"]
			Server.world.map["dirt"][id]["isHoed"] = true
			var data = {"d":Server.world.map["dirt"][id]}
			var response = Util.toMessage("ChangeTile",data)
			for player_id in Server.players.keys():
				Server.ws.get_peer(player_id).put_packet(response)
		("WATER"):
			var id = message["d"]["id"]
			Server.world.map["dirt"][id]["isWatered"] = true
			var data = {"d":Server.world.map["dirt"][id]}
			var response = Util.toMessage("ChangeTile",data)
			for player_id in Server.players.keys():
				Server.ws.get_peer(player_id).put_packet(response)
		("PICKAXE"):
			var id = message["d"]["id"]
			if Server.world.map["dirt"][id]["isHoed"] == true or Server.world.map["dirt"][id]["isWatered"] == true:
				Server.world.map["dirt"][id]["isWatered"] = false
				Server.world.map["dirt"][id]["isHoed"] = false
				var data = {"d":Server.world.map["dirt"][id]}
				var response = Util.toMessage("ChangeTile",data)
				for player_id in Server.players.keys():
					Server.ws.get_peer(player_id).put_packet(response)
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
