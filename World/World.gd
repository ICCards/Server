extends Node2D

#onready var TreeObject = preload("res://World/Decorations/Tree/TreeObject.tscn")
onready var Player = preload("res://World/Decorations/Player/Player.tscn")
onready var Terrian = $Terrian

var _uuid = preload("res://helpers/UUID.gd")
onready var uuid = _uuid.new()
var type = "world"
var rng = RandomNumberGenerator.new()
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
	"grass":{},
	"dark_grass":{},
	"tall_grass":{},
	"water":{},
	"tree":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"decorations":{"seed":{},"placable":{}},
	"tile": {},
}

#const NUM_FARM_OBJECTS = 550
#const NUM_GRASS_BUNCHES = 150
#const NUM_GRASS_TILES = 75
#const NUM_FLOWER_TILES = 250
#const MAX_GRASS_BUNCH_SIZE = 24

func _ready():
	set_meta('type',type)
	Server.world = self
	#generate_farm()

#func generate_farm():
#	for i in range(NUM_FARM_OBJECTS):
#		rng.randomize()
#		decoration_types.shuffle()
#		#object_name = object_types[0]
#		#object_variety = set_object_variety(object_name)
#		find_random_location_and_place_object(object_name, object_variety, i)

#func set_object_variety(name):
#	rng.randomize()
#	if name == "tree" or name == "tree stump":
#		treeTypes.shuffle()
#		return treeTypes[0]
#	elif name == "tree branch":
#		return rng.randi_range(0, 11)
#	else:
#		oreTypes.shuffle()
#		return oreTypes[0]

#func find_random_location_and_place_object(name, variety, i):
#	rng.randomize()
#	var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
#	place_object("tree", variety, location, true)
#	#if validate_location_and_remove_tiles(location):
#		#place_object("tree", variety, location, true)
#	#PlayerFarmApi.player_farm_objects.append([name, variety, location, true])
#
#func validate_location_and_remove_tiles(loc):
#	var space_state = get_world_2d().direct_space_state
#	# use global coordinates, not local to node
#	var result = space_state.intersect_ray(loc,loc)
#	return result.empty();
#
#func place_object(type, variety, loc, isFullGrowth):
#	if type == "tree":
#		var health = 5
#		var name = uuid.v4()
#		var treeObject = TreeObject.instance()
#		var position = World.map_to_world(loc) + Vector2(0, 24)
#		treeObject.name = name
#		Server.decoration_state[name] = {"p":position,"n":name,"t":type,"v":variety,"g":isFullGrowth,"h":health}
#		treeObject.initialize(variety, loc, isFullGrowth)
#		add_child(treeObject)
#		treeObject.position = position


func spawnPlayer(player_id):
	Server.players[player_id] ={}
	var player = Player.instance()
	player.name = str(player_id)
	characters.shuffle()
	player.data["character"] = characters.front()
	rng.randomize()
	var location = Vector2(rng.randi_range(0, 300), rng.randi_range(0, 300))
	#player.position = Ground.map_to_world(location)
	add_child(player,true)
	var data = {
		"c":characters.front(),
		"id":player_id,
		"p":location,
		"d":"DOWN",
		"t":OS.get_system_time_msecs()
	}
	Server.players[player_id] = data
	print("spawned player " + str(player_id))
	print(data)
	Server._spawnPlayer(data)


func _on_Node2D_area_entered(area:Area2D):
	pass # Replace with function body.
