extends Node2D
var randomNum
var treeObject
var loc
var health

func initialize(variety, _loc):
	randomNum = variety
	loc = _loc

func _ready():
	pass
	
func _on_BranchHurtBox_area_entered(_area):
	queue_free()
