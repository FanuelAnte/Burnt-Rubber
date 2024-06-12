extends Node

const car_resources = {
	0 : preload("res://Scripts/Resources/Cars/Charger.tres"),
	1 : preload("res://Scripts/Resources/Cars/GTI.tres"),
	2 : preload("res://Scripts/Resources/Cars/250GT.tres"),
	3 : preload("res://Scripts/Resources/Cars/Stratos.tres"),
	4 : preload("res://Scripts/Resources/Cars/Stingray.tres"),
	5 : preload("res://Scripts/Resources/Cars/2002Tii.tres")
}

const default_binds = {
	"Forward" : "Z",
	"Reverse" : "X",
	"Steer Left-Menu Left" : "Left",
	"Steer Right-Menu RIght" : "Right",
	"Boost-Menu Up" : "Up",
	"Drift-Menu Donw" : "Down",
#	"Accept" : "Enter",
#	"Pause-Back" : "Escape"
}

var binds = {
	"accelerate" : ["Forward", ""],
	"brake" : ["Reverse", ""],
	"steer_left" : ["Steer Left - Menu Left", ""],
	"steer_right" : ["Steer Right - Menu RIght", ""],
	"boost" : ["Boost - Menu Up", ""],
	"drift" : ["Drift - Menu Donw", ""],
#	"accept" : ["Accept", ""],
#	"pause" : ["Pause - Back", ""]
}

#Reset after exit.
var time_limit = 300
var counter_time = 3

var counter_time_left = "00"
var time_left = "00:00.000"

var is_counting_down = true
var zooming_enabled = true

var match_settings = {
	"team_color" : "",
	"car_resource": ""
}

var options_menu_parent = ""

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

var max_camera_zoom = Vector2(1, 1) * 2
var shake_power_factor = 2
var shake_length_factor = 1
var auto_aim_speed = 3

var starting_positions = {
	0 : Vector2(-128, 480),
	1 : Vector2(128, 480),
	2 : Vector2(0, 480)
}

func reset_essentials():
	Globals.time_limit = 300
	Globals.counter_time = 3
	Globals.is_counting_down = true
	
	Globals.score["red"] = 0
	Globals.score["blue"] = 0
