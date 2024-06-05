extends Node

var counter_time = 3
var counter_time_left = "00.000"

var is_counting_down = true

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

var time_left = "05:00.000"

var starting_positions = {
	0 : Vector2(-128, 480),
	1 : Vector2(128, 480)
#	2 : Vector2(0, 488)
}
