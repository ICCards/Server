extends Node2D

var rng = RandomNumberGenerator.new()
onready var tween = $Tween
onready var timer = $Timer
onready var tree_animation_player = $AnimationPlayer

var health
var treeObject
var adjusted_leaves_falling_pos

var desertTrees = ["1a", "1b", "2a", "2b"]

func _ready():
	pass
		
func _on_TreeHurtbox_area_entered(area):
	var data = {"id": name, "n": "tree"}
	Server.action("ON_HIT", data)
	health -= 1
	if health >= 4:
		pass
	elif health == 3:
		pass
			
			
func disable_tree_top_collision_box():
	$TreeTopArea/CollisionPolygon2D.set_deferred("disabled", true)

			
### Effect functions		
func initiateLeavesFallingEffect(tree):
	pass
#	if tree == Images.D_tree:
#		adjusted_leaves_falling_pos = Vector2(0, 50)
#	elif tree == Images.B_tree:
#		adjusted_leaves_falling_pos = Vector2(0, 25)
#	else: 
#		adjusted_leaves_falling_pos = Vector2(0, 0)
#	var leavesEffect = LeavesFallEffect.instance()
#	leavesEffect.initLeavesEffect(tree)
#	add_child(leavesEffect)
#	leavesEffect.global_position = global_position + adjusted_leaves_falling_pos
		
