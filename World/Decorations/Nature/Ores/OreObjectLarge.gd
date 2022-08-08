extends Node2D

var rng = RandomNumberGenerator.new()

var oreObject
var loc
var variety
var health

func initialize(_variety, _loc):
	variety = _variety
	loc = _loc

func _ready():
	pass

func _on_BigHurtBox_area_entered(_area):
	rng.randomize()
	var data = {"id": name, "n": "large_ore"}
	Server.action("ON_HIT", data)
	health -= 1
	if health == 0:
		$LargeOreOccupiedTiles/CollisionShape2D.set_deferred("disabled", true)

	if health != 0:
		pass

func _on_SmallHurtBox_area_entered(_area):
	rng.randomize()
	var data = {"id": name, "n": "large_ore"}
	Server.action("ON_HIT", data)
	health -= 1
	if health <= 0:
		queue_free()
	if health != 0:
		pass
