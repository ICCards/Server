extends Node2D

export var width := 300
export var height := 300
var openSimplexNoise := OpenSimplexNoise.new()
onready var Ground = $Ground
onready var Grass = $Grass
onready var _Tree = $Tree
onready var Stump = $Stump
onready var Log = $Log
onready var Ore = $Ore
onready var Ore_Large = $Ore_Large
onready var Flower = $Flower

onready var TreeObject = preload("res://World/Decorations/Nature/Trees/TreeObject.tscn")
onready var DesertTreeObject = preload("res://World/Decorations/Nature/Trees/DesertTreeObject.tscn")
onready var BranchObject = preload("res://World/Decorations/Nature/Trees/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Decorations/Nature/Trees/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Decorations/Nature/Ores/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Decorations/Nature/Ores/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Decorations/Nature/Grasses/TallGrassObject.tscn")
onready var FlowerObject = preload("res://World/Decorations/Nature/Grasses/FlowerObject.tscn")

#export var NUM_GRASS_BUNCHES = 500
#export var NUM_TREES = 1000
#export var NUM_LOGS = 1000
#export var NUM_STUMPS = 1000
#export var NUM_ORE = 1000
#export var NUM_ORE_LARGE = 1000
#export var NUM_FLOWER = 500
export var MAX_GRASS_BUNCH_SIZE = 500
var rng = RandomNumberGenerator.new()
onready var tile_maps = [_Tree,Stump,Log,Ore_Large,Ore,Flower]
var _uuid = preload("res://helpers/UUID.gd")
onready var uuid = _uuid.new()

var altittude = {}
var temperature = {}
var moisture = {}

var decoration_locations = []

func _ready() -> void:
	randomize()
	temperature = generate_map(5,300)
	moisture = generate_map(5,300)
	altittude = generate_map(5,150)
	build_terrian()
	generate_trees(get_parent().map["snow"].values(),"snow")
	generate_trees(get_parent().map["forest"].values(),"forest")
	generate_trees(get_parent().map["desert"].values(),"desert")
	generate_grass_bunches(get_parent().map["plains"].values(),"plains")
	generate_grass_bunches(get_parent().map["snow"].values(),"snow")
	generate_ores(get_parent().map["snow"].values(),"snow")
	generate_ores(get_parent().map["desert"].values(),"desert")
	generate_ores(get_parent().map["dirt"].values(),"dirt")
	generate_flowers(get_parent().map["forest"].values(),"forest")
	generate_flowers(get_parent().map["plains"].values(),"plains")
#	generate_grass_bunches()
#	generate_trees()
#	generate_ores()
#	generate_flowers()
	print("done")
	
func generate_map(octaves,period):
	var grid = {}
	openSimplexNoise.seed = randi()
	openSimplexNoise.octaves = octaves
	openSimplexNoise.period = period
	var custom_gradient = CustomGradientTexture.new()
	custom_gradient.gradient = Gradient.new()
	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
	custom_gradient.size = Vector2(width,height)
	var gradient_data = custom_gradient.get_data()
	gradient_data.lock()
	for x in width:
		for y in height:
			#var rand := floor((abs(openSimplexNoise.get_noise_2d(x,y)))*11)
			var gradient_value = gradient_data.get_pixel(x,y).r * 1.5
			var value = openSimplexNoise.get_noise_2d(x,y)
			value += gradient_value
			grid[Vector2(x,y)] = value
	return grid
	
func build_terrian():
	for x in width:
		for y in height:
			var pos = Vector2(x,y)
			var alt = altittude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			var id = uuid.v4()
			#Ocean
			if alt > 0.8:
				Ground.set_cell(x,y, 3)
				get_parent().map["ocean"][id] = (Vector2(x,y))
			#Beach	
			elif between(alt,0.75,0.8):
				Ground.set_cell(x,y, 5)
				get_parent().spawnable_locations.append(Vector2(x,y))
				get_parent().map["beach"][id] = (Vector2(x,y))
			#Biomes	
			elif between(alt,-1.4,0.8):
				#plains
				if between(moist,0,0.4) and between(temp,0.2,0.6):
					Ground.set_cell(x,y, 1)
					get_parent().map["plains"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["plains"].values())
				#forest
				elif between(moist,0.5,0.85) and temp > 0.6:
					Ground.set_cell(x,y, 2)
					get_parent().map["forest"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["forest"].values())
				#desert	
				elif temp > 0.6 and moist < 0.5:
					Ground.set_cell(x,y, 5)
					get_parent().map["desert"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["desert"].values())
				#snow	
				elif temp < 0.2:
					Ground.set_cell(x,y, 6)
					get_parent().map["snow"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["snow"].values())
				else:
					#dirt
					Ground.set_cell(x,y, 0)
					get_parent().map["dirt"][id] = (Vector2(x,y))
			else:
				pass
				#Ground.set_cell(x,y, 0)
				get_parent().map["dirt"][id] = (Vector2(x,y))
				#print(get_parent().map["dirt"])
			
func generate_grass_bunches(locations,biome):
	var NUM_GRASS_BUNCHES = int(locations.size()/100)
	for _i in range(NUM_GRASS_BUNCHES):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_grass_bunch(location,biome)
			

func create_grass_bunch(loc,biome):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		if isValidPosition(loc):
			var id = uuid.v4()
			get_parent().map["tall_grass"][id] = {"l":loc,"h":5,"b":biome}
			Grass.set_cellv(loc,0)
			decoration_locations.append(loc)
			var object = TallGrassObject.instance()
			object.biome = biome
			object.name = id
			object.position = Ground.map_to_world(loc) + Vector2(8, 32)
			add_child(object,true)
			
func generate_trees(locations,biome):
	print("Building "+biome+" Trees")
	var NUM_TREES = int(locations.size()/100)
	var NUM_STUMPS = int(locations.size()/120)
	var NUM_LOGS = int(locations.size()/140)
	print(NUM_TREES)
	print(NUM_STUMPS)
	print(NUM_LOGS)
	for _i in range(NUM_TREES):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		#print(location)
		create_tree(location,biome,"A")
	for _i in range(NUM_STUMPS):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_stump(location,biome,"A")
	for _i in range(NUM_LOGS):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_log(location,biome,"A")

func generate_ores(locations,biome):
	var NUM_ORE_LARGE = int(locations.size()/100)
	var NUM_ORE = int(locations.size()/120)
	for _i in range(NUM_ORE_LARGE):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_ore_large(location,biome,"A")
			
	for _i in range(NUM_ORE):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_ore(location,biome,"A")
			

func generate_flowers(locations,biome):
	print("Building "+biome+" Flowers")
	var NUM_FLOWER = int(locations.size()/100)
	for _i in range(NUM_FLOWER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_flower(location,biome)
			

func create_flower(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		get_parent().map["flower"][id] = {"l":loc,"h":5, "b":biome}
		Flower.set_cellv(loc,0)
		decoration_locations.append(loc)
		var object = FlowerObject.instance()
		object.name = id
		object.position = Ground.map_to_world(loc) + Vector2(16, 32)
		add_child(object,true)

func create_tree(loc,biome,variety):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["tree"][id] = {"l":loc,"h":8,"b":biome}
		_Tree.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		var object = TreeObject.instance()
		object.biome = biome
		object.health = 8
		object.initialize(variety, loc)
		object.position = Ground.map_to_world(loc) + Vector2(0, -8)
		object.name = id
		add_child(object,true)
		
func create_stump(loc,biome,variety):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["stump"][id] = {"l":loc,"h":3,"b":biome}
		Stump.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		var object = StumpObject.instance()
		object.health = 3
		object.name = id
		object.initialize(variety,loc)
		object.position = Ground.map_to_world(loc) + Vector2(4,0)
		add_child(object,true)
	
func create_log(loc,biome,variety):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["log"][id] = {"l":loc,"h":1,"b":biome}
		Log.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		var object = BranchObject.instance()
		object.name = id
		object.health = 1
		object.initialize(variety,loc)
		object.position = Ground.map_to_world(loc) + Vector2(16, 16)
		add_child(object,true)
		
func create_ore_large(loc,biome,variety):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["ore_large"][id] = {"l":loc,"h":8,"b":biome}
		Ore_Large.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		var object = OreObject.instance()
		object.health = 8
		object.name = id
		object.initialize(variety,loc)
		object.position = Ground.map_to_world(loc) 
		add_child(object,true)

func create_ore(loc,biome,variety):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["ore"][id] = {"l":loc,"h":3,"b":biome}
		Ore.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		var object = SmallOreObject.instance()
		object.health = 3
		object.name = id
		object.initialize(variety,loc)
		object.position = Ground.map_to_world(loc) + Vector2(16, 24)
		add_child(object,true)

func check_64x64(loc):
	for tile_map in tile_maps:
		if not tile_map.get_cellv(loc) == -1 \
		or not tile_map.get_cellv(loc + Vector2(1,0)) == -1 \
		or not tile_map.get_cellv(loc + Vector2(0,-1)) == -1 \
		or not tile_map.get_cellv(loc + Vector2(1,-1)) == -1:
			return false
	return true

func isValidPosition(loc):
	if decoration_locations.has(loc):
		return false
	else:
		return true

func between(val, start, end):
	if start <= val and val < end:
		return true	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		get_tree().reload_current_scene()

#get_parent().map["dirt"][id] = {"l":Vector2(x,y), "isWatered":false, "isHoed":false} 	
#			match rand:
#				float(0):
#					get_parent().map["dirt"][id] = {"l":Vector2(x,y), "isWatered":false, "isHoed":false}
#				float(1):
#					get_parent().map["dark_grass"][id] = (Vector2(x,y)) 
#				float(2):	
#					get_parent().map["grass"][id] = (Vector2(x,y))
#				float(3):	
#					get_parent().map["water"][id] = (Vector2(x,y)) 
#				float(4):	
#					get_parent().map["water"][id] = (Vector2(x,y)) 
