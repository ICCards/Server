extends Node

var day_timer:Timer
var night_timer:Timer
var is_daytime = true

var season = "Spring"
var day = 1
var hour = 6
var minute = 00

var is_timer_started

const LENGTH_OF_CYCLE = 24
const LENGTH_OF_TRANSITION = 8


signal advance_day
signal advance_season

func next_season(current_season):
	if current_season == "Spring":
		return "Summer"
	elif current_season == "Summer":
		return "Fall"
	elif current_season == "Fall":
		return "Winter"
	else:
		return "Spring"

func _ready():
	day_timer = Timer.new()
	day_timer.set_wait_time(LENGTH_OF_CYCLE / 2)
	day_timer.one_shot = true
	add_child(day_timer)
	
	night_timer = Timer.new()
	night_timer.set_wait_time(LENGTH_OF_CYCLE / 2)
	night_timer.one_shot = true
	add_child(night_timer)
	start_day_timer()

func start_day_timer() -> void:
	day_timer.start()
	yield(day_timer, "timeout")
	is_daytime = false
	yield(get_tree().create_timer(LENGTH_OF_TRANSITION), "timeout")
	print("set night")
	Server.day = false
	start_night_timer()
	
	
func start_night_timer() -> void:
	night_timer.start()
	yield(night_timer, "timeout")
	Server.day_num += 1
	for id in Server.decorations["seed"].keys():
		var tile_id = Server.decorations["seed"][id]["g"]
		var tile = Server.world.map["dirt"][tile_id]
		if tile["isWatered"]:	
			var days_remaining = Server.decorations["seed"][id]["d"]
			if days_remaining > 0:
				Server.decorations["seed"][id]["d"] -= 1
				print(Server.decorations["seed"][id]["d"])
	if day == 31:
		Server.day_num = 1
		Server.season = next_season(season)
	yield(get_tree().create_timer(LENGTH_OF_TRANSITION), "timeout")
	Server.day = true
	start_day_timer()

