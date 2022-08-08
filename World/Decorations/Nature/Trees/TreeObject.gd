extends Node2D

var rng = RandomNumberGenerator.new()

var treeObject
var loc
var variety
var hit_dir
var health
var adjusted_leaves_falling_pos 
var biome

func initialize(inputVar, _loc):
	variety = inputVar
	loc = _loc

### Tree hurtbox
func _on_Hurtbox_area_entered(_area):
	var data = {"id": name, "n": "tree"}
	Server.action("ON_HIT", data)
	health -= 1
	if health == 7:
		pass
	if health >= 4:
		pass
	elif health == 3:
		pass
	elif health >= 1 :
		pass
	elif health == 0: 
		queue_free()
	
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

func _on_TreeTopArea_area_entered(_area):
	pass

func _on_TreeTopArea_area_exited(_area):
	pass

func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
