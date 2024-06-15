extends HBoxContainer

var main_parent
var remap_prompt

onready var action_name_lbl = $"%ActionNameLbl"
onready var action_bind_lbl = $"%ActionBindLbl"
onready var remap_btn = $"%RemapBtn"

var action_name
var event_name
var index

func _ready():
	index = get_parent().get_node(self.name).get_index()
	
	if index == 0:
		remap_btn.grab_focus()
	
	main_parent = get_parent().get_parent().get_parent().get_parent()
	remap_prompt = get_parent().get_parent().get_parent().get_parent().get_child(2)
	
	action_name_lbl.text = Globals.binds.values()[index][0]
	action_name = Globals.binds.keys()[index]
	
func _process(delta):
	var input_event_list = InputMap.get_action_list(Globals.binds.keys()[index])
	if input_event_list != []:
		event_name = input_event_list[0]
		Globals.binds.values()[index][1] = OS.get_scancode_string(event_name.scancode)
	else:
		event_name = null
		Globals.binds.values()[index][1] = " - "
		
	action_bind_lbl.text = Globals.binds.values()[index][1]
	
func map_new_button(button):
	if event_name != null:
		InputMap.action_erase_event(action_name, event_name)
	
	var new_event = InputEventKey.new()
	new_event.set_scancode(button)
	InputMap.action_add_event(action_name, new_event)
	
	yield(get_tree().create_timer(0.2), "timeout")
	main_parent.is_remapping = false
	
	remap_btn.grab_focus()
	
func _on_RemapBtn_pressed():
	main_parent.is_remapping = true
	InterfaceAudioComponent.play_accept()
	remap_btn.release_focus()
	
	remap_prompt.open(Globals.binds.values()[index][1], Globals.binds.values()[index][0])
	var key_scancode = yield(remap_prompt, "key_selected")
	map_new_button(key_scancode)
	
