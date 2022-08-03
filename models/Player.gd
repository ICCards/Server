extends KinematicBody2D

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING,
	CHANGE_TILE
}

var direction
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
var counter = -1
var collisionMask = null

func _ready():
	pass

func _process(_delta):
	pass
#	match state:
#		MOVEMENT:
#			movement_state(_delta)
			
func toJson():
	return {
		"c":character,
		"cp":companion,
		"id":player_id,
		"p":position,
		"d":direction,
		"t":time,
		"principal":principal,
		"o":online
	}
	
func input_update(input, game_state : Dictionary):
	#calculate state of object for the given input
	var vect = Vector2(0, 0)
	if input.net_input[0]: #W
		vect.y -= 7
		direction = "UP"
	if input.net_input[1]: #A
		vect.x -= 7
		direction = "LEFT"
	if input.net_input[2]: #S
		vect.y += 7
		direction = "DOWN"
	if input.net_input[3]: #D
		vect.x += 7
		direction = "RIGHT"
	#move_and_collide for "solid" stationary objects
	var collision = move_and_collide(vect)
	if collision:
		vect = vect.slide(collision.normal)
		move_and_collide(vect)
	Server.rpc_id(0,"move",name,vect,direction)
	
		
#reset object state to that in a given game_state, executed once per rollback 
func reset_state(game_state : Dictionary):
	#check if this object exists within the checked game_state
	if game_state.has(name):
		position.x = game_state[name]['x']
		position.y = game_state[name]['y']
		Server.rpc_id(0,"move",name,position,direction)
	else:
		queue_free()


func frame_start():
	pass

func frame_end():
	pass


func get_state():
	#return dict of state variables to be stored in Frame_States
	return {'x': position.x, 'y': position.y, 'counter': counter, 'collisionMask': collisionMask}

func _on_Player_tree_entered():
	pass

func _on_Area2D_area_entered(_area:Area2D):
	pass
	
