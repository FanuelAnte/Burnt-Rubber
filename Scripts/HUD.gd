extends Control


onready var pause_menu = $"%PauseMenu"
onready var transition_texture = $"%TransitionTexture"
onready var blue_score = $"%BlueScore"
onready var red_score = $"%RedScore"
onready var time = $"%Time"
onready var counter_time = $"%CounterTime"
onready var counter_rect = $"%CounterRect"
onready var anim_player = $"%AnimPlayer"
onready var player_speed = $"%PlayerSpeed"
onready var puck_speed = $"%PuckSpeed"
onready var goal_text = $"%GoalText"
onready var goal_rect = $"%GoalRect"
onready var match_end_rect = $"%MatchEndRect"
onready var match_end_text = $"%MatchEndText"

func _ready():
	transition_texture.rect_position = Vector2(-112, 0)
	play_load()
	
func _physics_process(delta):
	if Globals.is_counting_down:
		counter_rect.show()
	else:
		counter_rect.hide()
		
	blue_score.text = str(Globals.score["blue"]).pad_zeros(2)
	red_score.text = str(Globals.score["red"]).pad_zeros(2)
	
	time.text = Globals.time_left
	player_speed.text = str(Globals.player_speed) + " UPH" 
	puck_speed.text = str(Globals.puck_speed) + " UPH" 
	
	counter_time.text = Globals.counter_time_left
	
func play_transition():
	anim_player.play("ScreenTransition")

func play_load():
	anim_player.play("LoadTransition")

func play_goal(color):
	goal_rect.show()
	goal_text.self_modulate = color
	anim_player.play("GoalAnimation")
	
func play_match_end_animation():
	match_end_rect.show()
	anim_player.play("MatchEndAnimation")
	
func _on_AnimPlayer_animation_finished(anim_name):
	if anim_name == "MatchEndAnimation":
		get_tree().change_scene("res://Scenes/Menus/EndMatchScreen.tscn")
