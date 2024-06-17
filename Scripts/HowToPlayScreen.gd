extends Control


onready var back_btn = $"%BackBtn"

func _ready():
	back_btn.grab_focus()

func _on_BackBtn_pressed():
	InterfaceAudioComponent.play_back()
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
