extends KinematicBody2D

onready var weapon = $MeleeSwing
onready var weaponCollisionShape = $MeleeSwing/CollisionShape2D

var data = {}
var rng = RandomNumberGenerator.new()
var spawning = true
var type = "player"
var direction = "DOWN"
var MAX_SPEED := 12.5
var ACCELERATION := 6
var FRICTION := 8
var delta
var velocity := Vector2.ZERO

#var character
#var acc_index
#var headAtr_index
#var pants_index
#var shirts_index
#var shoes_index

func _ready():
	set_meta('type',type)

func _process(_delta) -> void:
	delta = _delta

func movement_state(direction):
	var input_vector = Vector2.ZERO			
	if direction == "UP":
		input_vector.y -= 1.0
	if direction == "DOWN":
		input_vector.y += 1.0
	if direction == "LEFT":
		input_vector.x -= 1.0
	if direction == "RIGHT"	:
		input_vector.x += 1.0
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_collide(velocity * MAX_SPEED)

func adjust_position_from_direction(pos):
	if direction == "UP":
		pos += Vector2(0, -36)
	elif direction == "DOWN":
		pos += Vector2(0, 20)
	elif direction == "LEFT":
		pos += Vector2(-32, -8)
	elif direction == "RIGHT":
		pos += Vector2(32, -8)
	return pos	
		
func swing():
	weaponCollisionShape.disabled = false
	match (direction):
		("up"):
			var position = Vector2(0,-36)
			weapon.set_position(position)
		("down"):
			var position = Vector2(0, 20)
			weapon.set_position(position)
		("right"):
			var position = Vector2(32, -8)
			weapon.set_position(position)
		("left"):
			var position = Vector2(-32, -8)
			weapon.set_position(position)
	weaponCollisionShape.disabled = true

func _on_Player_tree_entered():
	pass
	#spawning = false

func _on_Area2D_area_entered(_area:Area2D):
	pass
	#var name = self.name
	#if spawning:
		#queue_free()
		#get_parent().spawnPlayer(name)
	#else:
		#pass
