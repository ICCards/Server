extends Node2D
onready var treeTypes = ['A','B', 'C', 'D', 'E']
var rng = RandomNumberGenerator.new()
var treeObject
var loc 
var health

func initialize(variety, _loc):
	loc = _loc

func _ready():
	pass
		
func _on_StumpHurtBox_area_entered(_area):
	var data = {"id": name, "n": "stump"}
	Server.action("ON_HIT", data)
	health -= 1
	if health <= 0: 
		queue_free()
	else:
		pass
