extends KinematicBody2D


onready var chase_timer = $"%ChaseTimer"
onready var collider = $"%Collider"
onready var sprite = $"%Sprite"
onready var camera = $"%Camera"
export var is_player = false

var current_slip_speed

export (Resource) var car_details
var can_chase_ball = true

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_angle

var starting_position = Vector2.ZERO
var starting_rotation = Vector2.ZERO

export (String, "red", "blue") var team_color

func _ready():
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
	
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * car_details.acceleration_factor * delta
#	velocity = move_and_slide(velocity)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity.x *= 1.5
		velocity.y *= 1.5
	
	
func apply_friction():
	if velocity.length() < 1:
		velocity = Vector2.ZERO
	var friction_force = velocity * car_details.friction
	var drag_force = velocity * velocity.length() * car_details.drag
	if velocity.length() < 70:
		friction_force *= 3
	acceleration += drag_force + friction_force
	
func get_input():
	current_slip_speed = car_details.slip_speed
	var turn = 0
	var puck = get_tree().get_nodes_in_group("puck")[0].global_position
	if !Globals.is_counting_down:
		if is_player:
			if Input.is_action_pressed("steer_right"):
				
				turn += 1
			if Input.is_action_pressed("steer_left"):
				turn -= 1
				
			if Input.is_action_pressed("accelerate"):
				acceleration = transform.x * car_details.engine_power
			if Input.is_action_pressed("brake"):
				acceleration = transform.x * car_details.braking
			
			if Input.is_action_pressed("drift"):
				current_slip_speed = car_details.slip_speed/4
		
		else:
			var direction = (Vector2(0, 0) - self.global_position)

			if (puck - self.global_position).length() > 32:
				if can_chase_ball:
					direction = (puck - self.global_position)
			else:
				can_chase_ball = false
				chase_timer.start(stepify(rand_range(1, 2), 0.05))
			
			var angle = rad2deg(self.transform.x.angle_to(direction))
			
			if abs(angle) <= 170:
				turn += sign(angle) * 1
				acceleration = transform.x * car_details.engine_power
			
			elif abs(angle) > 170:
				turn += sign(angle) * 1
				acceleration = transform.x * car_details.braking
				
	steer_angle = turn * deg2rad(car_details.steering_angle)
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * car_details.wheel_base / 2.0
	var front_wheel = position + transform.x * car_details.wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = car_details.traction_slow
	if velocity.length() > current_slip_speed:
		traction = car_details.traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), car_details.max_speed_reverse)
	rotation = new_heading.angle()
		

func reset_position():
	self.position = starting_position
	self.rotation_degrees = starting_rotation

func _on_Timer_timeout():
	can_chase_ball = true
