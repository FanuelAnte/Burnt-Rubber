extends Control


onready var start_btn = $"%StartBtn"
onready var options_btn = $"%OptionsBtn"
onready var multiplayer_btn = $"%MultiplayerBtn"
onready var exit_btn = $"%ExitBtn"

func _ready():
	start_btn.grab_focus()

func _on_StartBtn_pressed():
	get_tree().change_scene("res://Scenes/BaseGame.tscn")
	
func _on_ExitBtn_pressed():
	get_tree().quit()
