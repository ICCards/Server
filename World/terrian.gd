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
export var NUM_GRASS_BUNCHES = 500
export var NUM_TREES = 1000
export var NUM_LOGS = 1000
export var NUM_STUMPS = 1000
export var NUM_ORE = 1000
export var NUM_ORE_LARGE = 1000
export var NUM_FLOWER = 500
export var MAX_GRASS_BUNCH_SIZE = 500
var rng = RandomNumberGenerator.new()
onready var tile_maps = [_Tree,Stump,Log,Ore_Large,Ore,Flower]
var _uuid = preload("res://helpers/UUID.gd")
onready var uuid = _uuid.new()

var decoration_locations = []

func _ready() -> void:
	randomize()
	openSimplexNoise.seed = randi()
	openSimplexNoise.octaves = 5
	generate_map()
	generate_grass_bunches()
	generate_trees()
	generate_ores()
	generate_flowers()
	print("done")
	
func generate_map() -> void:
	for x in width:
		for y in height:
			var rand := floor((abs(openSimplexNoise.get_noise_2d(x,y)))*6)
			var id = uuid.v4()
			match rand:
				float(0):
					get_parent().map["dirt"][id] = {"l":Vector2(x,y), "isWatered":false, "isHoed":false}
				float(1):
					get_parent().map["dark_grass"][id] = (Vector2(x,y)) 
				float(2):	
					get_parent().map["grass"][id] = (Vector2(x,y))
				float(3):	
					get_parent().map["water"][id] = (Vector2(x,y)) 
				float(4):	
					get_parent().map["water"][id] = (Vector2(x,y)) 
			Ground.set_cell(x,y, rand)

func generate_grass_bunches():
	for _i in range(NUM_GRASS_BUNCHES):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidGrassTile(location):
			create_grass_bunch(location)

func create_grass_bunch(loc):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		if isValidGrassTile(loc):
			var id = uuid.v4()
			get_parent().map["tall_grass"][id] = {"l":loc,"h":5}
			Grass.set_cellv(loc,0)
			
func generate_trees():
	for _i in range(NUM_TREES):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidTreeTile(location):
			create_tree(location)
	for _i in range(NUM_STUMPS):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidTreeTile(location):
			create_stump(location)
	for _i in range(NUM_LOGS):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidTreeTile(location):
			create_log(location)

func generate_ores():
	for _i in range(NUM_ORE_LARGE):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidOreTile(location):
			create_ore_large(location)
	for _i in range(NUM_ORE):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidOreTile(location):
			create_ore(location)
			
func generate_flowers():
	for _i in range(NUM_FLOWER):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidTreeTile(location):
			create_flower(location)

func create_flower(loc):
	var id = uuid.v4()
	if check_loc(loc) and isValidPosition(loc):
		get_parent().map["flower"][id] = {"l":loc,"h":5}
		Flower.set_cellv(loc,0)
		decoration_locations.append(loc)

func create_tree(loc):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["tree"][id] = {"l":loc,"h":8}
		_Tree.set_cellv(loc,0)
		decoration_locations.append(loc)
		
func create_stump(loc):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["stump"][id] = {"l":loc,"h":3}
		Stump.set_cellv(loc,0)
		decoration_locations.append(loc)
	
func create_log(loc):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["log"][id] = {"l":loc,"h":1}
		Log.set_cellv(loc,0)
		decoration_locations.append(loc)
		
func create_ore_large(loc):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["ore_large"][id] = {"l":loc,"h":8}
		Ore_Large.set_cellv(loc,0)
		decoration_locations.append(loc)

func create_ore(loc):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		get_parent().map["ore"][id] = {"l":loc,"h":3}
		Ore.set_cellv(loc,0)
		decoration_locations.append(loc)

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		get_tree().reload_current_scene()
