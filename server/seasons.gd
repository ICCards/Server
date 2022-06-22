extends Node

var day_timer:Timer
var night_timer:Timer
var is_daytime = true

var season = "Spring"
var day = 1
var hour = 6
var minute = 00
var time_start
var time_now

var is_timer_started

const LENGTH_OF_CYCLE = 48
const LENGTH_OF_TRANSITION = 8


signal advance_day
signal advance_season

func next_season(current_season):
	match current_season:
		"Spring":
			return "Summer"
		"Summer":
			return "Fall"
		"Fall":
			return "Winter"
		"Winter":
			return "Spring"
			
	if current_season == "Spring":
		return "Summer"
	elif current_season == "Summer":
		return "Fall"
	elif current_season == "Fall":
		return "Winter"
	else:
		return "Spring"

func _ready():
	time_start = OS.get_unix_time()
	day_timer = Timer.new()
	day_timer.set_wait_time(LENGTH_OF_CYCLE / 2)
	day_timer.one_shot = true
	add_child(day_timer)
	
	night_timer = Timer.new()
	night_timer.set_wait_time(LENGTH_OF_CYCLE / 2)
	night_timer.one_shot = true
	add_child(night_timer)
	start_day_timer()
	
func _process(delta):
	time_now = OS.get_unix_time()
	var time_elapsed = time_now - time_start
	if time_elapsed == 49:
		time_start = OS.get_unix_time()
		Server.time_elapsed = 0
	else:
		Server.time_elapsed = time_elapsed


func start_day_timer() -> void:
	day_timer.start()
	yield(day_timer, "timeout")
	Server.day = false
	print("set night")
	start_night_timer()
	
	
func start_night_timer() -> void:
	night_timer.start()
	yield(night_timer, "timeout")
	Server.day_num += 1
	Server.day = true
	for id in Server.decorations["seed"].keys():
		var tile_id = Server.decorations["seed"][id]["g"]
		var tile = Server.world.map["dirt"][tile_id]
		print(tile)
		if tile["isWatered"]:	
			tile["isWatered"] = false
			var days_remaining = Server.decorations["seed"][id]["d"]
			if days_remaining > 0:
				Server.decorations["seed"][id]["d"] -= 1
				print(Server.decorations["seed"][id]["d"])
	if Server.day_num >= 31:
		Server.day_num = 1
		Server.season = next_season(season)
	start_day_timer()
