extends KinematicBody2D

class_name Player

var online = true
var character
var principal
var player_id
var location
var direction
var companion
var time = OS.get_system_time_msecs()

func _ready():
	pass

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

func _on_Player_tree_entered():
	pass

func _on_Area2D_area_entered(_area:Area2D):
	pass
	
