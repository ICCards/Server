extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460
onready var itemSprite = $Sprite
onready var animationPlayer = $AnimationPlayer


var player
var being_picked_up = false
var being_added_to_inventory = false
var item_name
var randomInt
var rng = RandomNumberGenerator.new()
var adjustedPosition
var direction
var distance

func initItemDropType(item_name_input,player):
	rng.randomize()
	randomInt = rng.randi_range(1, 5)	
	item_name = item_name_input
	player = player
	adjustPosition(randomInt)
	direction = adjustedPosition.direction_to(player.global_position)
	distance = adjustedPosition.distance_to(player.global_position)
#	if item_name == "Cobblestone":
#		item_name = "Stone"
#	api_call_name = item_name
#	if item_name == "Stone":
#		api_call_name = "stone ore"

func adjustPosition(animation):
	if animation == 1:
		adjustedPosition = global_position + Vector2(48, 0)
	elif animation == 2:
		adjustedPosition = global_position + Vector2(-48, 0)
	elif animation == 3:
		adjustedPosition = global_position + Vector2(24, -25)
	elif animation == 4:
		adjustedPosition = global_position + Vector2(-24, -25)
	elif animation == 5:
		adjustedPosition = global_position + Vector2(0, -6)


