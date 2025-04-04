extends RigidBody2D


signal zoom_camera(zoom_value)

var has_zoomed_out = false
var has_zoomed_in = true

onready var object_audio_component = $"%ObjectAudioComponent"

onready var chase_timer = $"%ChaseTimer"
onready var collider = $"%Collider"
onready var sprite = $"%Sprite"
onready var camera = $"%Camera"
onready var boost_timer = $"%BoostTimer"
onready var boost_cooldown = $"%BoostCooldown"
onready var proximity_line = $"%ProximityLine"
onready var collision_damp_timer = $"%CollisionDampTimer"
onready var ice_particles_l = $"%IceParticlesL"
onready var ice_particles_r = $"%IceParticlesR"

export var is_player = false
export (Resource) var car_details
var can_chase_ball = true
var has_stalled = false

var is_drifting = false
var can_boost = true
var is_steering = true

var velocity = Vector2.ZERO
var turn = 0

var steer_intensity = 0
var max_speed = 0
var engine_power = 0

var puck

var starting_position = Vector2.ZERO
var starting_rotation = Vector2.ZERO

export (String, "red", "blue") var team_color

func _integrate_forces(state):
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed

func _ready():
	puck = get_tree().get_nodes_in_group("puck")[0].global_position
	
	steer_intensity = car_details.base_steer_intensity
	max_speed = car_details.max_speed
	engine_power = car_details.engine_power
	
	if is_player:
		camera.current = true
	else:
		camera.current = false
		
	var car_index = get_parent().get_node(self.name).get_index()
		
	if team_color == "blue":
		sprite.frame = car_details.car_sprite
		starting_position = Globals.starting_positions[car_index] * -1
		starting_rotation = 90
	elif team_color == "red":
		sprite.frame = car_details.car_sprite + 6
		starting_position = Globals.starting_positions[car_index]
		starting_rotation = -90
		
	self.position = starting_position
	self.rotation_degrees = starting_rotation
	
	var capsule = CapsuleShape2D.new()
	capsule.set_radius(6)
	capsule.set_height(car_details.collider_height)
	
	collider.shape = capsule
	
func _process(delta):
	puck = get_tree().get_nodes_in_group("puck")[0].global_position
	get_input()
	
	if is_player and stepify(global_position.distance_to(puck), 1) < 128:
		proximity_line.show()
		update_proximity_line()
		
		#TODO: Auto-aim if in close proximity.
		if !is_steering:
			var direction = (puck - self.global_position)
			var angle = rad2deg(self.transform.x.angle_to(direction))
			
			turn += sign(angle) * Globals.auto_aim_speed
			linear_damp = 1
			
	else:
		proximity_line.hide()
		
	#Dynamic Zoom: Make it an option in settings.
	if is_player and Globals.zooming_enabled:
		if clamp(linear_velocity.length(), 0, car_details.max_speed) > (car_details.max_speed)/2:
			if !has_zoomed_out:
				emit_signal("zoom_camera", Globals.max_camera_zoom)
				has_zoomed_out = true
				has_zoomed_in = false
		else:
			if !has_zoomed_in:
				emit_signal("zoom_camera", Vector2(1, 1))
				has_zoomed_in = true
				has_zoomed_out = false
		
func _physics_process(_delta):
	#TODO: Draw a straight line between you and the ball when you get within 32 to 128 pixels of the puck to show the boost trajectory and effect.
	if !Globals.is_counting_down:
		applied_force = velocity
		var norm_speed = stepify(range_lerp(linear_velocity.length(), 0, max_speed, 0.5, 1), 0.5)
		
		if linear_velocity.length() > car_details.min_steer_speed:
			applied_torque = turn * steer_intensity * norm_speed
			
		else:
			angular_velocity = 0
			
#		if is_drifting or abs(angular_velocity) > 2:
#			ice_particles_l.emitting = true
#			ice_particles_r.emitting = true
#		else:
#			ice_particles_l.emitting = false
#			ice_particles_r.emitting = false
		
	else:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		
	if is_player:
		Globals.player_speed = stepify(linear_velocity.length(), 1)
	
func get_input():
	turn = 0
	is_steering = false
	
	if !Globals.is_counting_down and !Globals.stop_engines:
		if is_player:
			if Input.is_action_pressed("steer_right") and boost_timer.is_stopped():
				is_steering = true
				turn += 1
			if Input.is_action_pressed("steer_left") and boost_timer.is_stopped():
				turn -= 1
				is_steering = true
				
			if Input.is_action_pressed("accelerate"):
				velocity = transform.x * engine_power
				linear_damp = 1
				
			elif Input.is_action_pressed("brake"):
				velocity = transform.x * car_details.braking * -1
				linear_damp = 1
				
			else:
				velocity = Vector2()
				linear_damp = 3
			
			if Input.is_action_pressed("drift"):
				steer_intensity = car_details.drift_steer_intensity
				is_drifting = true
			else:
				steer_intensity = car_details.base_steer_intensity
				is_drifting = false
				
			if Input.is_action_just_pressed("boost") and can_boost:
				boost_timer.start()
				max_speed = car_details.boost_max_speed
				engine_power = car_details.boost_engine_power
			
		else:
			var direction = (Vector2(0, 0) - self.global_position)
			
			if (puck - self.global_position).length() > 32:
				if can_chase_ball:
					direction = (puck - self.global_position)
			else:
				can_chase_ball = false
				chase_timer.start(stepify(rand_range(1, 2), 0.05))
				
			var angle = rad2deg(self.transform.x.angle_to(direction))
				
			if abs(angle) <= 140:
				turn += sign(angle) * 1
				velocity = transform.x * car_details.engine_power
				linear_damp = 1
				
			elif abs(angle) > 140:
				turn += sign(angle) * 1
				velocity = transform.x * car_details.braking * -1
				linear_damp = 1
	
func update_proximity_line():
	proximity_line.set_as_toplevel(true)
	proximity_line.points[0] = global_position
	proximity_line.points[1] = puck
	
func move_camera(amount):
	camera.offset = Vector2(rand_range(-amount.x, amount.x), rand_range(-amount.y, amount.y))
	
func camera_shake(length, power):
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(self, "move_camera", Vector2(power, power), Vector2(0, 0), length)
	
func reset_position():
	self.position = starting_position
	self.rotation_degrees = starting_rotation
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
func _on_ChaseTimer_timeout():
	can_chase_ball = true
	
func _on_BoostTimer_timeout():
	can_boost = false
	boost_cooldown.start()
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "max_speed", car_details.max_speed, 1)
	
	engine_power = car_details.engine_power
	
func _on_BoostCooldown_timeout():
	can_boost = true
	
func _on_CarBase_body_entered(body):
	var shake_factor = 0
	
	if !body.is_in_group("cars") or !body.is_in_group("puck"):
		angular_damp = 15
		collision_damp_timer.start()
	
	if (body.is_in_group("puck") or body.is_in_group("cars")) and linear_velocity.length() < body.linear_velocity.length():
		shake_factor = range_lerp(body.linear_velocity.length(), 0, max_speed, 0.2, 1)
	else:
		shake_factor = range_lerp(linear_velocity.length(), 0, max_speed, 0.5, 1)
	
	camera_shake(Globals.shake_length_factor * shake_factor, Globals.shake_power_factor * shake_factor)
	
	var volume_level
	if body.is_in_group("cars") or body.is_in_group("puck"):
		if body.linear_velocity.length() > linear_velocity.length():
			volume_level = linear2db(range_lerp(body.linear_velocity.length(), 0, 1000, 0, 1))
		else:
			volume_level = linear2db(range_lerp(linear_velocity.length(), 0, 1000, 0, 1))
			
	else:
		volume_level = linear2db(range_lerp(linear_velocity.length(), 0, 1000, 0, 1))
	
	object_audio_component.play_car_hit(volume_level)
	
func _on_CarBase_zoom_camera(zoom_value):
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(camera, "zoom", zoom_value, 1.5)
	
func _on_CollisionDampTimer_timeout():
	angular_damp = 5
