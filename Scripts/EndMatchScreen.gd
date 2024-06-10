extends Control


onready var blue_score = $"%BlueScore"
onready var red_score = $"%RedScore"
onready var rematch_btn = $"%RematchBtn"

func _ready():
	rematch_btn.grab_focus()
	
func _process(delta):
	blue_score.text = str(Globals.score["blue"]).pad_zeros(2)
	red_score.text = str(Globals.score["red"]).pad_zeros(2)
	
func _on_MainMenuBtn_pressed():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	Globals.reset_essentials()
