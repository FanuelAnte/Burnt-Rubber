extends RigidBody2D


func _ready():
	pass
	
func _integrate_forces(state):
	rotation = 0
	if state.linear_velocity.length() > 500:
		state.linear_velocity=state.linear_velocity.normalized() * 500

func _physics_process(delta):
	#TODO: Reset everything if the ball is out of bounds.
	if self.position.x > Globals.field_extents["x"] or self.position.x < (Globals.field_extents["x"] * -1):
		reset_everything()
	if self.position.x > Globals.field_extents["y"] or self.position.x < (Globals.field_extents["y"] * -1):
		reset_everything()

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
	
	for car in get_tree().get_nodes_in_group("cars"):
		car.reset_position()
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("goal"):
		
		if area.team_color == "red":
			Globals.score["blue"] += 1
		
		elif area.team_color == "blue":
			Globals.score["red"] += 1
	
	reset_everything()
