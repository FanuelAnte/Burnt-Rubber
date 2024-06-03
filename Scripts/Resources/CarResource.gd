extends Resource

class_name car_resource

export (String, "Charger", "GTI", "250GT", "Stratos", "Stingray", "2002Tii") var car_name

##
#export (int) var wheel_base = 25
#export (int) var steering_angle = 30
##

export (int) var engine_power = 400
export (int) var max_speed = 200
export (int) var min_steer_speed = 20
export (int) var steer_intensity = 1500

##
#export (int) var acceleration_factor = 3
#export (float) var friction = -0.9
#export (float) var drag = -0.002
##

export (int) var braking = 200

##
#export (int) var max_speed_reverse = 200
#export (int) var slip_speed = 200
#export (float) var traction_fast = 0.05
#export (float) var traction_slow = 0.8
##

export (int) var collider_height = 8
export (int, 0, 5) var car_sprite
