extends Control


onready var blue_checkbox = $"%BlueCheckbox"
onready var red_checkbox = $"%RedCheckbox"
onready var car_sprites = $"%CarSprites"
onready var previous_car_btn = $"%PreviousCarBtn"
onready var next_car_btn = $"%NextCarBtn"
onready var car_name_lbl = $"%CarNameLbl"
onready var duration_lbl = $"%DurationLbl"

var car_index = 0
var offset = false
var match_duration = 3
var minute_text

var team_color = "blue"

func _ready():
	next_car_btn.grab_focus()
	
func _process(delta):
	if offset:
		car_sprites.frame = car_index + 6
	else:
		car_sprites.frame = car_index
	
	if match_duration > 1:
		minute_text = " Minutes"
	else:
		minute_text = " Minute"
		
	car_name_lbl.text = Globals.car_resources[car_index].car_name
	duration_lbl.text = str(match_duration) + minute_text
	
func _on_PreviousCarBtn_pressed():
	if car_index > 0:
		car_index -= 1

func _on_NextCarBtn_pressed():
	if car_index < 5:
		car_index += 1

func _on_BlueCheckbox_pressed():
	team_color = "blue"
	offset = false

func _on_RedCheckbox_pressed():
	team_color = "red"
	offset = true

func _on_StartBtn_pressed():
	var car = Globals.car_resources[car_index]
	Globals.match_settings["team_color"] = team_color
	Globals.match_settings["car_resource"] = car
	Globals.match_duration = int((match_duration) * 60)
	Globals.time_limit = Globals.match_duration
	get_tree().change_scene("res://Scenes/BaseGame.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")

func _on_IncDuration_pressed():
	if match_duration < 15:
		match_duration += 1

func _on_DecDuration_pressed():
	if match_duration > 1:
		match_duration -= 1
	
