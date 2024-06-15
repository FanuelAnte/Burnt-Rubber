extends RigidBody2D


var hud

onready var object_audio_component = $"%ObjectAudioComponent"

func _integrate_forces(state):
	if state.linear_velocity.length() > Globals.max_puck_speed:
		state.linear_velocity = state.linear_velocity.normalized() * Globals.max_puck_speed
		
func _ready():
	hud = get_tree().get_nodes_in_group("hud")[0]
	
func _physics_process(delta):
	Globals.puck_speed = stepify(linear_velocity.length(), 1)
	
func reset_everything():
	#TODO: Make this less shitty
	self.linear_velocity = Vector2.ZERO
	self.call_deferred("set_mode", MODE_STATIC)
	yield(get_tree().create_timer(1), "timeout")
	
	hud.play_transition()
	
	yield(get_tree().create_timer(0.4), "timeout")
	
	hud.goal_rect.hide()
	
	Globals.counter_time = 3
	Globals.is_counting_down = true
	
	self.linear_velocity = Vector2.ZERO
	self.position = Vector2.ZERO
	
	for mark in get_tree().get_nodes_in_group("tire_tracks"):
		mark.clear_points()
	
	for car in get_tree().get_nodes_in_group("cars"):
		car.reset_position()
	
	self.call_deferred("set_mode", MODE_CHARACTER)
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("goal"):
		if area.team_color == "red":
			hud.play_goal(Color("28669a"))
			Globals.score["blue"] += 1
		
		elif area.team_color == "blue":
			hud.play_goal(Color("ce1a1a"))
			Globals.score["red"] += 1
			
		reset_everything()
	
func _on_Puck_body_entered(body):
	object_audio_component.play_crash()
