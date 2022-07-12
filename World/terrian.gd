extends Node2D

export var width := 2048
export var height := 2048
var openSimplexNoise := OpenSimplexNoise.new()
onready var Ground = $Ground
onready var Grass = $Grass
onready var _Tree = $Tree
onready var Stump = $Stump
onready var Log = $Log
onready var Ore = $Ore
onready var Ore_Large = $Ore_Large
onready var Flower = $Flower
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
				elif between(moist,0.35,0.85) and temp > 0.6:
					Ground.set_cell(x,y, 2)
					get_parent().map["forest"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["forest"].values())
				#desert	
				elif temp > 0.7 and moist < 0.4:
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
		if isValidGrassTile(loc):
			var id = uuid.v4()
			get_parent().map["tall_grass"][id] = {"l":loc,"h":5,"b":biome}
			Grass.set_cellv(loc,0)
			
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
		create_tree(location,biome)
	for _i in range(NUM_STUMPS):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_stump(location,biome)
	for _i in range(NUM_LOGS):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_log(location,biome)

#func generate_ores():
#	for _i in range(NUM_ORE_LARGE):
#		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
#		if isValidOreTile(location):
#			create_ore_large(location)
#	for _i in range(NUM_ORE):
#		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
#		if isValidOreTile(location):
#			create_ore(location)
#
#func generate_flowers():
#	for _i in range(NUM_FLOWER):
#		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
#		if isValidTreeTile(location):
#			create_flower(location)
#
#func create_flower(loc):
#	var id = uuid.v4()
#	if check_loc(loc) and isValidPosition(loc):
#		get_parent().map["flower"][id] = {"l":loc,"h":5}
#		Flower.set_cellv(loc,0)
#		decoration_locations.append(loc)

func create_tree(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["tree"][id] = {"l":loc,"h":8,"b":biome}
		_Tree.set_cellv(loc,0)
		decoration_locations.append(loc)
		
func create_stump(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["stump"][id] = {"l":loc,"h":3,"b":biome}
		Stump.set_cellv(loc,0)
		decoration_locations.append(loc)
	
func create_log(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["log"][id] = {"l":loc,"h":1,"b":biome}
		Log.set_cellv(loc,0)
		decoration_locations.append(loc)
		
#func create_ore_large(loc):
#	var id = uuid.v4()
#	if check_64x64(loc) and isValidPosition(loc):
#		get_parent().map["ore_large"][id] = {"l":loc,"h":8}
#		Ore_Large.set_cellv(loc,0)
#		decoration_locations.append(loc)
#
#func create_ore(loc):
#	var id = uuid.v4()
#	if check_64x64(loc) and isValidPosition(loc):
#		get_parent().map["ore"][id] = {"l":loc,"h":3}
#		Ore.set_cellv(loc,0)
#		decoration_locations.append(loc)

func isValidGrassTile(position):
	if Ground.get_cellv(position) == 1 or Ground.get_cellv(position) == 2:
		return true
	else: 
		return false
		
func isValidTreeTile(position):
	if Ground.get_cellv(position) == 1 or Ground.get_cellv(position) == 2:
		return true
	else: 
		return false

func isValidOreTile(position):
	if Ground.get_cellv(position) == 0:
		return true
	else: 
		return false

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
		
func check_loc(loc):
	for tile_map in tile_maps:
		if not tile_map.get_cellv(loc) == -1:
			return false
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
