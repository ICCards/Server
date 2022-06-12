extends Area2D

var rng = RandomNumberGenerator.new()
onready var world = get_tree().current_scene

var location_of_object
var variety
var showFullTree
var type = "tree"
func initialize(inputVar, loc, ifFullTree):
	variety = inputVar
	location_of_object = loc
	showFullTree = ifFullTree

func _ready():
	set_tree_top_collision_shape()
	if !showFullTree:
		disable_tree_top_collision_box()
		#$TreeHurtbox/treeHurtBox.disabled = true
		#$TreeSprites/TreeTop.visible = false
		#$TreeSprites/TreeBottom.visible = false
		#$StumpHurtBox/stumpHurtBox.disabled = false
	

### Tree modulate functions
func set_tree_top_collision_shape():
	if variety == "A":
		$TreeTopArea/A.disabled = false
	elif variety == "B":
		$TreeTopArea/B.disabled = false
	elif variety == "C":
		$TreeTopArea/C.disabled = false
	elif variety == "D":
		$TreeTopArea/D.disabled = false
	elif variety == "E":
		$TreeTopArea/E.disabled = false

func disable_tree_top_collision_box():
	if variety == "A":
		$TreeTopArea/A.set_deferred("disabled", true)
	elif variety == "B":
		$TreeTopArea/B.set_deferred("disabled", true)
	elif variety == "C":
		$TreeTopArea/C.set_deferred("disabled", true)
	elif variety == "D":
		$TreeTopArea/D.set_deferred("disabled", true)
	elif variety == "E":
		$TreeTopArea/E.set_deferred("disabled", true)


func _on_TreeObject_area_entered(area:Area2D):
	if area.type == "tree" or area.type == "world":
		Server.decoration_state.erase(area.name)
		queue_free()
	else:
		pass
