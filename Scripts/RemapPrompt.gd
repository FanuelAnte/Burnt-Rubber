extends Control


signal key_selected(scancode)

onready var action_name_lbl = $"%ActionNameLbl"
onready var event_lbl = $"%EventLbl"

var last_pressed_button

func _ready():
#	set_process_unhandled_key_input(false)
	pass
	
func _input(event):
	if event is InputEventKey and (event.scancode == 16777221 or event.scancode == 16777217):
		pass
	else:
		if event is InputEventKey and event.is_pressed():# and (event.scancode != KEY_ENTER or event.scancode != KEY_ESCAPE):
			if self.is_visible_in_tree():
				InterfaceAudioComponent.play_accept()
			
			last_pressed_button = event.scancode
			emit_signal("key_selected", last_pressed_button)
			close()
		
func open(event, action):
	show()
	action_name_lbl.text = action
	event_lbl.text = event
#	set_process_unhandled_key_input(true)
	
func close():
	hide()
#	set_process_unhandled_key_input(false)
