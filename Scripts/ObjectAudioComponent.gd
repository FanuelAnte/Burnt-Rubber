extends Node2D


onready var crash_1 = $"%Crash1"
onready var crash_2 = $"%Crash2"

onready var ball_crash = [crash_1, crash_2]

var rng = RandomNumberGenerator.new()

func _ready():
	pass
	
func play_crash():
	randomize()
	
	var crash = ball_crash[rng.randi_range(0, ball_crash.size() - 1)]
	
	if !crash.playing:
		crash.pitch_scale = rng.randf_range(1, 2)
		crash.play()
