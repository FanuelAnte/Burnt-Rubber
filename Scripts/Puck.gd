extends RigidBody2D


func _integrate_forces(state):
	if state.linear_velocity.length() > 400:
		state.linear_velocity = state.linear_velocity.normalized() * 400
		
func _physics_process(delta):
	Globals.puck_speed = stepify(linear_velocity.length(), 1)
	
func reset_everything():
	#TODO: Make this less shitty
	self.linear_velocity = Vector2.ZERO
	yield(get_tree().create_timer(1), "timeout")
	
	var hud =  get_tree().get_nodes_in_group("hud")[0]
	hud.play_transition()
	
	yield(get_tree().create_timer(0.4), "timeout")
	
	Globals.counter_time = 3
	Globals.is_counting_down = true
	
	self.linear_velocity = Vector2.ZERO
	self.position = Vector2.ZERO
	
	for mark in get_tree().get_nodes_in_group("tire_tracks"):
		mark.clear_points()
	
	for car in get_tree().get_nodes_in_group("cars"):
		car.reset_position()
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("goal"):
		
		if area.team_color == "red":
			Globals.score["blue"] += 1
		
		elif area.team_color == "blue":
			Globals.score["red"] += 1
	
	reset_everything()
