extends Control

onready var play_btn = $"%PlayBtn"
onready var exit_btn = $"%ExitBtn"

func _ready():
	play_btn.grab_focus()
	
func _on_PlayBtn_pressed():
	get_tree().change_scene("res://Scenes/Menus/MatchSetupScreen.tscn")
	
func _on_ExitBtn_pressed():
	get_tree().quit()
	
func _on_InputMapMenuBtn_pressed():
	Globals.input_menu_parent = "main"
	get_tree().change_scene("res://Scenes/Menus/InputMapMenu.tscn")

func _on_SettingsBtn_pressed():
	Globals.settings_menu_parent = "main"
	get_tree().change_scene("res://Scenes/Menus/SettingsMenu.tscn")
	
