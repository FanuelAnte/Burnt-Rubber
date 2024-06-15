extends Control

onready var input_remapper = $"%InputRemapper"

var is_remapping = false

func _ready():
	pass
	
func _process(delta):
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and !is_remapping and self.is_visible_in_tree():
		InterfaceAudioComponent.play_navigate()
	
func first_button_grab_focus():
	input_remapper.remap_btn.grab_focus()
	
func _on_BackBtn_pressed():
	if !is_remapping:
		InterfaceAudioComponent.play_back()
		if Globals.input_menu_parent == "main":
			get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
		else:
			self.hide()
			get_parent().menu_open = false
			get_parent().pause_menu_margin.show()
			get_parent().resume_grab_focus()
		
		Globals.save_settings()
