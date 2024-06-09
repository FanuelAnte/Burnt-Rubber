extends Control

onready var play_btn = $"%PlayBtn"
onready var options_btn = $"%OptionsBtn"
onready var multiplayer_btn = $"%MultiplayerBtn"
onready var exit_btn = $"%ExitBtn"

func _ready():
	play_btn.grab_focus()

func _on_PlayBtn_pressed():
	get_tree().change_scene("res://Scenes/BaseGame.tscn")
	
func _on_ExitBtn_pressed():
	get_tree().quit()
