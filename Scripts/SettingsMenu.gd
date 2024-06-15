extends Control


onready var dec_master_vol_btn = $"%DecMasterVolBtn"
onready var master_vol_lbl = $"%MasterVolLbl"
onready var inc_master_vol_btn = $"%IncMasterVolBtn"
onready var dec_sfx_vol_btn = $"%DecSfxVolBtn"
onready var sfx_vol_lbl = $"%SfxVolLbl"
onready var inc_sfx_vol_btn = $"%IncSfxVolBtn"
onready var dec_music_vol_btn = $"%DecMusicVolBtn"
onready var music_vol_lbl = $"%MusicVolLbl"
onready var inc_music_vol_btn = $"%IncMusicVolBtn"
onready var back_button = $"%BackButton"

func _ready():
	dec_master_vol_btn.grab_focus()
	
func _process(delta):
	if self.is_visible_in_tree():
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
			InterfaceAudioComponent.play_navigate()
		
	master_vol_lbl.text = str(Globals.master_volume)
	sfx_vol_lbl.text = str(Globals.sfx_volume)
	music_vol_lbl.text = str(Globals.music_volume)
	
func first_button_grab_focus():
	dec_master_vol_btn.grab_focus()

func _on_BackButton_pressed():
	InterfaceAudioComponent.play_back()
	if Globals.settings_menu_parent == "main":
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	else:
		self.hide()
		get_parent().menu_open = false
		get_parent().pause_menu_margin.show()
		get_parent().resume_grab_focus()
	
	Globals.save_settings()
	
func _on_DecMasterVolBtn_pressed():
	InterfaceAudioComponent.play_back()
	if Globals.master_volume > 0:
		Globals.master_volume -= 1
	
	Globals.save_settings()
	
func _on_IncMasterVolBtn_pressed():
	InterfaceAudioComponent.play_accept()
	if Globals.master_volume < 10:
		Globals.master_volume += 1
	
	Globals.save_settings()
	
func _on_DecSfxVolBtn_pressed():
	InterfaceAudioComponent.play_back()
	if Globals.sfx_volume > 0:
		Globals.sfx_volume -= 1
	
	Globals.save_settings()
	
func _on_IncSfxVolBtn_pressed():
	InterfaceAudioComponent.play_accept()
	if Globals.sfx_volume < 10:
		Globals.sfx_volume += 1
	
	Globals.save_settings()
	
func _on_DecMusicVolBtn_pressed():
	InterfaceAudioComponent.play_back()
	if Globals.music_volume > 0:
		Globals.music_volume -= 1
	
	Globals.save_settings()
	
func _on_IncMusicVolBtn_pressed():
	InterfaceAudioComponent.play_accept()
	if Globals.music_volume < 10:
		Globals.music_volume += 1
		
	Globals.save_settings()
