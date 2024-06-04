extends Control

onready var transition_texture = $"%TransitionTexture"
onready var blue_score = $"%BlueScore"
onready var red_score = $"%RedScore"
onready var time = $"%Time"
onready var counter_time = $"%CounterTime"
onready var counter_rect = $"%CounterRect"
onready var anim_player = $"%AnimPlayer"
onready var speed = $"%Speed"

func _ready():
#	play_transition()
	transition_texture.rect_position = Vector2(-400, 0)

func _physics_process(delta):
	if Globals.is_counting_down:
		counter_rect.show()
	else:
		counter_rect.hide()
		
	blue_score.text = str(Globals.score["blue"]).pad_zeros(2)
	red_score.text = str(Globals.score["red"]).pad_zeros(2)
	
	time.text = Globals.time_left
	speed.text = str(Globals.player_speed)
	
	counter_time.text = Globals.counter_time_left

func play_transition():
	anim_player.play("ScreenTransition")
