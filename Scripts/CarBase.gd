extends RigidBody2D


onready var chase_timer = $"%ChaseTimer"
onready var collider = $"%Collider"
onready var sprite = $"%Sprite"
onready var camera = $"%Camera"
export var is_player = false

export (Resource) var car_details
var can_chase_ball = true
var has_stalled = false

var velocity = Vector2.ZERO
var turn = 0

var steer_intensity = 0

var starting_position = Vector2.ZERO
var starting_rotation = Vector2.ZERO

export (String, "red", "blue") var team_color

func _integrate_forces(state):
	if state.linear_velocity.length() > car_details.max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * car_details.max_speed

func _ready():
	steer_intensity = car_details.base_steer_intensity
	
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
	
	var capsule = CapsuleShape2D.new()
	capsule.set_radius(6)
	capsule.set_height(car_details.collider_height)
	
	collider.shape = capsule
	
func _process(delta):
	get_input()
	
func _physics_process(delta):
	if !Globals.is_counting_down:
		applied_force = velocity
		var norm_speed = stepify(range_lerp(linear_velocity.length(), 0, car_details.max_speed, 0.5, 1), 0.5)
		
		if linear_velocity.length() > car_details.min_steer_speed:
			applied_torque = turn * steer_intensity * norm_speed
		else:
			angular_velocity = 0
	else:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
	
func get_input():
	turn = 0
	var puck = get_tree().get_nodes_in_group("puck")[0].global_position
	if !Globals.is_counting_down:
		if is_player:
			if Input.is_action_pressed("steer_right"):
				turn += 1
			if Input.is_action_pressed("steer_left"):
				turn -= 1
				
			if Input.is_action_pressed("accelerate"):
				velocity = transform.x * car_details.engine_power
				linear_damp = 1
				
			elif Input.is_action_pressed("brake"):
				velocity = transform.x * car_details.braking * -1
				linear_damp = 1
				
			else:
				velocity = Vector2()
				linear_damp = 3
			
			if Input.is_action_pressed("drift"):
				steer_intensity = car_details.drift_steer_intensity
			else:
				steer_intensity = car_details.base_steer_intensity
			
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
			
func reset_position():
	self.position = starting_position
	self.rotation_degrees = starting_rotation
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
	
func _on_Timer_timeout():
	can_chase_ball = true
