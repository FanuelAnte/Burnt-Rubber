extends Node2D

var time_limit = 300

func _ready():
	pass

func _process(delta):
	if Globals.is_counting_down:
		if Globals.counter_time > 0:
			Globals.counter_time -= delta
		else:
			Globals.is_counting_down = false
		
		var total_seconds = int(Globals.counter_time)
		var seconds = int(total_seconds % 60)
		
		Globals.counter_time_left = str(seconds)
	
	else:
		if time_limit > 0:
			time_limit -= delta
		else:
			time_limit = 0
			pass
			#TODO: End Game.
		
		var total_seconds = int(time_limit)
		var minutes = int((total_seconds % 3600) / 60)
		var seconds = int(total_seconds % 60)
		var milliseconds = int((time_limit - total_seconds) * 1000)
		
		Globals.time_left = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + "." + str(milliseconds).pad_zeros(3)
