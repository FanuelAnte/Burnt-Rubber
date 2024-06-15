extends Control

onready var play_btn = $"%PlayBtn"
onready var exit_btn = $"%ExitBtn"

func _ready():
	play_btn.grab_focus()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		InterfaceAudioComponent.play_navigate()
	
func _on_PlayBtn_pressed():
	InterfaceAudioComponent.play_accept()
	get_tree().change_scene("res://Scenes/Menus/MatchSetupScreen.tscn")
	
func _on_ExitBtn_pressed():
	get_tree().quit()
	
func _on_InputMapMenuBtn_pressed():
	InterfaceAudioComponent.play_accept()
	Globals.input_menu_parent = "main"
	get_tree().change_scene("res://Scenes/Menus/InputMapMenu.tscn")

func _on_SettingsBtn_pressed():
	InterfaceAudioComponent.play_accept()
	Globals.settings_menu_parent = "main"
	get_tree().change_scene("res://Scenes/Menus/SettingsMenu.tscn")
	
