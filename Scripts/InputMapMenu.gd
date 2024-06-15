extends Control

onready var input_remapper = $"%InputRemapper"

func _ready():
	pass
	
func first_button_grab_focus():
	input_remapper.remap_btn.grab_focus()
	
func _on_BackBtn_pressed():
	if Globals.input_menu_parent == "main":
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	else:
		self.hide()
		get_parent().menu_open = false
		get_parent().pause_menu_margin.show()
		get_parent().resume_grab_focus()
	
	Globals.save_settings()
