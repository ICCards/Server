extends Node2D

var variety
var bodyEnteredFlag = false
var bodyEnteredFlag2 = false
var grass
var biome
var grass_list

func _ready():
	pass

func _on_Area2D_body_entered(_body):
	pass
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	
func _on_VisibilityNotifier2D_screen_exited():
	visible = false

func _on_BackArea2D_body_entered(body):
	bodyEnteredFlag2 = true

func _on_BackArea2D_body_exited(body):
	bodyEnteredFlag2 = false
