extends Node

var data = {}
var rng = RandomNumberGenerator.new()
var spawning = true

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
        

func _on_Player_tree_entered():
	spawning = false
