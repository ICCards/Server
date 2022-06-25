extends Node
func action(player_id,message):
	message["id"] = player_id
	match message["t"]:
		("MOVEMENT"):
			print("updating movement")
			print(message)
			if Server.players[player_id]["t"] < message["d"]["t"]:
				Server.players[player_id]["p"] = message["d"]["p"]
				Server.players[player_id]["d"] = message["d"]["d"]
		("SWING"):
			var response = Util.toMessage("ReceivedAction", message)
			for id in Server.players.keys():
				Server.ws.get_peer(id).put_packet(response)
		("ON_HIT"):
			onHit(message)
			var response = Util.toMessage("ReceivedAction", message)
			for id in Server.players.keys():
				Server.ws.get_peer(id).put_packet(response)
		("PLACE_ITEM"):
			var id = message["d"]["id"]
			var object_type = message["d"]["t"]
			Server.decorations[object_type][id] = message["d"]
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
				Server.decorations[object_type].erase(id)
