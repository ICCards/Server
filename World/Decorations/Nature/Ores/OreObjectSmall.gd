extends Node2D

onready var world = get_tree().current_scene
var oreObject
var position_of_object
var variety
var health

func initialize(varietyInput, inputPos):
	variety = varietyInput
	position_of_object = inputPos
	
func _ready():
	pass

func _on_SmallHurtBox_area_entered(_area):
	var data = {"id": name, "n": "ore"}
	Server.action("ON_HIT", data)
	health -= 1
	if health == 0:
		queue_free()
	if health != 0:
		pass
