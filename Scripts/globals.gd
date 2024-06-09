extends Node

#Reset after exit.
var time_limit = 300
var counter_time = 3
var is_counting_down = true
var counter_time_left = "00.000"
var time_left = "05:00.000"

#Reset after exit.
var score = {
	"red": 0,
	"blue": 0
}

var field_extents = {
	"x" : 320,
	"y" : 576
}

#make this multiplayer friendly
var player_speed = 0

var puck_speed = 0
var max_puck_speed = 350

var max_camera_zoom = Vector2(2, 2)
var shake_power_factor = 2
var shake_length_factor = 1


var starting_positions = {
	0 : Vector2(-128, 480),
	1 : Vector2(128, 480),
	2 : Vector2(0, 480)
}
