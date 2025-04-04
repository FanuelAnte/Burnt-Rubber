extends Control

onready var input_map_menu = $"%InputMapMenu"
onready var settings_menu = $"%SettingsMenu"

onready var pause_menu_margin = $"%PauseMenuMargin"

onready var blue_score = $"%BlueScore"
onready var red_score = $"%RedScore"
onready var resume_btn = $"%ResumeBtn"

var paused = false
var menu_open = false

func _ready():
	if paused:
		resume_btn.grab_focus()
	
func _process(delta):
	if !menu_open and self.is_visible_in_tree():
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			InterfaceAudioComponent.play_navigate()
		
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			pause()
		else:
			if !menu_open:
				resume()
			
	blue_score.text = str(Globals.score["blue"]).pad_zeros(2)
	red_score.text = str(Globals.score["red"]).pad_zeros(2)

func resume_grab_focus():
	resume_btn.grab_focus()
	
func pause():
	InterfaceAudioComponent.play_back()
	get_tree().set_deferred("paused", true)
	resume_btn.grab_focus()
	paused = true
	self.show()

func resume():
	InterfaceAudioComponent.play_accept()
	get_tree().set_deferred("paused", false)
	paused = false
	self.hide()
	
func _on_ResumeBtn_pressed():
	resume()
	
func _on_EndMatchBtn_pressed():
	resume()
	MusicComponent.game_is_active = false
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	Globals.reset_essentials()
	
func _on_InputMapMenuBtn_pressed():
	InterfaceAudioComponent.play_accept()
	menu_open = true
	pause_menu_margin.hide()
	Globals.input_menu_parent = "game"
	input_map_menu.show()
	input_map_menu.first_button_grab_focus()
	
func _on_SettingsBtn_pressed():
	InterfaceAudioComponent.play_accept()
	menu_open = true
	pause_menu_margin.hide()
	Globals.settings_menu_parent = "game"
	settings_menu.show()
	settings_menu.first_button_grab_focus()

func _on_RestartBtn_pressed():
	resume()
	get_tree().reload_current_scene()
#	get_tree().change_scene("res://Scenes/Menus/MatchSetupScreen.tscn")
	Globals.reset_essentials()
	
