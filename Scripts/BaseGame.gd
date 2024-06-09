extends Node2D

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
		if Globals.time_limit > 0:
			Globals.time_limit -= delta
		else:
			Globals.time_limit = 0
			#TODO: End Game.
			get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
			
			Globals.reset_essentials()
			
		var total_seconds = int(Globals.time_limit)
		var minutes = int((total_seconds % 3600) / 60)
		var seconds = int(total_seconds % 60)
		var milliseconds = int((Globals.time_limit - total_seconds) * 1000)
		
		Globals.time_left = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + "." + str(milliseconds).pad_zeros(3)
