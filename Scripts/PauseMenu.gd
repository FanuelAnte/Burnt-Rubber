extends Control


onready var blue_score = $"%BlueScore"
onready var red_score = $"%RedScore"
onready var resume_btn = $"%ResumeBtn"

var paused = false

func _ready():
	if paused:
		resume_btn.grab_focus()
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			pause()
	
	blue_score.text = str(Globals.score["blue"]).pad_zeros(2)
	red_score.text = str(Globals.score["red"]).pad_zeros(2)
	
func pause():
	get_tree().set_deferred("paused", true)
	resume_btn.grab_focus()
	paused = true
	self.show()

func resume():
	get_tree().set_deferred("paused", false)
	paused = false
	self.hide()
	
func _on_ResumeBtn_pressed():
	resume()
	
func _on_EndMatchBtn_pressed():
	resume()
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	
	Globals.reset_essentials()
