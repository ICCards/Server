extends KinematicBody2D

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING,
	CHANGE_TILE
}

var direction = "DOWN"
var online = true
var character
var principal
var player_id
var location
var companion
var time = OS.get_system_time_msecs()
var input_vector = Vector2.ZERO
var MAX_SPEED := 12.5
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO
func _ready():
	pass

func _process(_delta) -> void:
	match state:
		MOVEMENT:
			movement_state(_delta)
			
func toJson():
	return {
		"c":character,
		"cp":companion,
		"id":player_id,
		"p":location,
		"d":direction,
		"t":time,
		"principal":principal,
		"o":online
	}

func movement_state(delta):
	input_vector = Vector2.ZERO
	match direction:
		"UP":
			input_vector.y -= 1.0
		"DOWN":
			input_vector.y += 1.0
		"LEFT":
			input_vector.x -= 1.0
		"RIGHT":
			input_vector.x += 1.0
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_collide(velocity * MAX_SPEED)
	Server.players[player_id]["p"] = position
	Server.players[player_id]["d"] = direction

func _on_Player_tree_entered():
	pass

func _on_Area2D_area_entered(_area:Area2D):
	pass
	
