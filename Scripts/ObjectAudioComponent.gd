extends Node2D


onready var puck_hits = $"%PuckHits"
onready var car_hits = $"%CarHits"
onready var goal = $"%Goal"

var rng = RandomNumberGenerator.new()

func _ready():
	pass
	
func play_puck_hit(volume_level):
	randomize()
	
	var hit = puck_hits.get_child(rng.randi_range(0, puck_hits.get_child_count() - 1))
	hit.volume_db = volume_level
	
	if !hit.playing:
		hit.pitch_scale = rng.randf_range(1, 1.1)
		hit.play()

func play_car_hit(volume_level):
	randomize()
	
	var hit = car_hits.get_child(rng.randi_range(0, car_hits.get_child_count() - 1))
	hit.volume_db = volume_level
	
	if !hit.playing:
		hit.pitch_scale = rng.randf_range(1, 1.1)
		hit.play()
		
func play_goal():
	if !goal.playing:
		goal.play()
		
