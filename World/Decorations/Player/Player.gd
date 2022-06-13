extends Node

var data = {}
var rng = RandomNumberGenerator.new()
var spawning = true
var type = "player"
var directon 
onready var weapon = $MeleeSwing
onready var weaponCollisionShape = $MeleeSwing/CollisionShape2D
#var character
#var acc_index
#var headAtr_index
#var pants_index
#var shirts_index
#var shoes_index

func _on_Area2D_area_entered(_area:Area2D):
    var name = self.name
    if spawning:
        queue_free()
        get_parent().spawnPlayer(name)
    else:
        pass
        
func swing():
    weaponCollisionShape.disabled = false
    match (directon):
        ("up"):
            var position = Vector2(0,-36)
            weapon.set_position(position)
        ("down"):
            var position = Vector2(0, 20)
            weapon.set_position(position)
        ("right"):
            var position = Vector2(32, -8)
            weapon.set_position(position)
        ("left"):
            var position = Vector2(-32, -8)
            weapon.set_position(position)
    weaponCollisionShape.disabled = true

func _on_Player_tree_entered():
	spawning = false