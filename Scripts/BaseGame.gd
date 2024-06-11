extends Node2D

onready var car_base = preload("res://Scenes/CarBase.tscn")

onready var blue_team = $"%BlueTeam"
onready var red_team = $"%RedTeam"

func _ready():
	#TODO: fix for odd match-ups and 1v1.
	randomize()
	var cars = []
	
	for i in range(2):
		var car = car_base.instance()
		car.team_color = "blue"
		car.car_details = Globals.car_resources[int(stepify(rand_range(0, 5), 1))]
		
		cars.append(car)
		
	for i in range(2):
		var car = car_base.instance()
		car.team_color = "red"
		car.car_details = Globals.car_resources[int(stepify(rand_range(0, 5), 1))]
		
		cars.append(car)
	
	for car in cars:
		if car.team_color == Globals.match_settings["team_color"]:
			car.car_details = Globals.match_settings["car_resource"]
			car.is_player = true
			break
	
	for car in cars:
		if car.team_color == "blue":
			blue_team.add_child(car)
		elif car.team_color == "red":
			red_team.add_child(car)
	
	#TODO: add random resource assignmnet for AI Cars.
	
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
			get_tree().change_scene("res://Scenes/Menus/EndMatchScreen.tscn")
			
		var total_seconds = int(Globals.time_limit)
		var minutes = int((total_seconds % 3600) / 60)
		var seconds = int(total_seconds % 60)
		var milliseconds = int((Globals.time_limit - total_seconds) * 1000)
		
		Globals.time_left = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + "." + str(milliseconds).pad_zeros(3)
