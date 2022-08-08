extends Node2D

onready var rng = RandomNumberGenerator.new()
var variety
var bodyEnteredFlag = false

func _ready():
	variety = rng.randi_range(1, 20)

func _on_Area2D_body_entered(_body):
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false
