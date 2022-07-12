extends Node2D

#onready var TreeObject = preload("res://World/Decorations/Tree/TreeObject.tscn")
onready var Player = preload("res://World/Decorations/Player/Player.tscn")
onready var Terrian = $Terrian

var _uuid = preload("res://helpers/UUID.gd")
onready var uuid = _uuid.new()
var type = "world"
var rng = RandomNumberGenerator.new()
var spawnable_locations = []
var characters = ["human_male", "human_female", "lesser_demon_male", "ogre_female", "ogre_male", "water_draganoid_female", "water_draganoid_male", "seraphim_female", "seraphim_male", "goblin_male",  "goblin_female", "demi_wolf_male", "demi_wolf_female", "human_female", "lesser_demon_female", "lesser_spirit", "succubus"]
#var decoration_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
#var tall_grass_types = ["dark green", "green", "red", "yellow"]
#var treeTypes = ['A','B', 'C', 'D', 'E']
#var oreTypes = ["Stone", "Cobblestone"]
#var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

#var object_name = "tree"
#var position_of_object
#var object_variety = "A"

var map = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"tile": {},
}

func _ready():
	set_meta('type',type)
	Server.world = self

func spawnPlayer(player_id,principal):
	var player = Player.new()
	player.name = str(player_id)
	characters.shuffle()
	player.data["character"] = characters.front()
	rng.randomize()
	var location = Vector2(rng.randi_range(0, 300), rng.randi_range(0, 300))
	#player.position = Ground.map_to_world(location)
	add_child(player,true)
	player.characters = characters.front()
	player.principal = principal
	player.player_id = player_id
	player.location = spawnable_locations[rng.randi_range(0, spawnable_locations.size() - 1)]
	player.direction = "DOWN"
	Server.players[player.player_id] = player.toJson()
	print("spawned player " + str(player_id))
	print(player.toJson())
	Server._spawnPlayer(player.toJson())

func _on_Node2D_area_entered(area:Area2D):
	pass # Replace with function body.
