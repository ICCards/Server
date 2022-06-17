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
export var NUM_TREES = 5000
export var NUM_LOGS = 1000
export var NUM_STUMPS = 1000
export var NUM_ORE = 3000
export var NUM_ORE_LARGE = 1000
export var NUM_FLOWER = 500
export var MAX_GRASS_BUNCH_SIZE = 1000
var rng = RandomNumberGenerator.new()
onready var tile_maps = [_Tree,Stump,Log,Ore_Large,Ore,Flower]

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
			match rand:
				float(0):
					get_parent().map["dirt"].append(Vector2(x,y)) 
				float(1):
					get_parent().map["dark_grass"].append(Vector2(x,y)) 
				float(2):	
					get_parent().map["grass"].append(Vector2(x,y))
				float(3):	
					get_parent().map["water"].append(Vector2(x,y)) 
				float(4):	
					get_parent().map["water"].append(Vector2(x,y)) 
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
			get_parent().map["tall_grass"].append(loc)
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

func generate_flowers():
	for _i in range(NUM_FLOWER):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidTreeTile(location):
			create_flower(location)

func generate_ores():
	for _i in range(NUM_ORE):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, 0 - height))
		if isValidOreTile(location):
			create_ore_large(location)
	for _i in range(NUM_ORE_LARGE):
		var location = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
		if isValidOreTile(location):
			create_ore(location)

func create_flower(loc):
	if check_loc(loc):
		get_parent().map["flower"].append(loc)
		Flower.set_cellv(loc,0)
	else:
		rng.randomize()
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		create_tree(loc)

func create_tree(loc):
	if check_64x64(loc):
		get_parent().map["tree"].append(loc)
		_Tree.set_cellv(loc,0)
	else:
		rng.randomize()
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		create_tree(loc)
		
func create_stump(loc):
	if check_64x64(loc):
		get_parent().map["stump"].append(loc)
		Stump.set_cellv(loc,0)
	else:
		rng.randomize()
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		create_stump(loc)
	
func create_log(loc):
	if check_64x64(loc):
		get_parent().map["log"].append(loc)
		Log.set_cellv(loc,0)
	else:
		rng.randomize()
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		create_log(loc)
		
func create_ore_large(loc):
	if check_64x64(loc):
		get_parent().map["ore_large"].append(loc)
		Ore_Large.set_cellv(loc,0)
	else:
		rng.randomize()
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		create_ore_large(loc)

func create_ore(loc):
	if check_64x64(loc):
		get_parent().map["ore"].append(loc)
		Ore.set_cellv(loc,0)
	else:
		rng.randomize()
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		create_ore(loc)

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

func check_loc(loc):
	for tile_map in tile_maps:
		if not tile_map.get_cellv(loc) == -1:
			return false
	return true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		get_tree().reload_current_scene()