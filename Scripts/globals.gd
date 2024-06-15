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
	"accelerate" : ["Forward", ""],
	"brake" : ["Reverse", ""],
	"boost" : ["Boost", ""],
	"steer_left" : ["Steer Left", ""],
	"steer_right" : ["Steer Right", ""],
	"drift" : ["Drift", ""]
}

var binds = {
	"accelerate" : ["Forward", ""],
	"steer_left" : ["Steer Left", ""],
	"steer_right" : ["Steer Right", ""],
	"brake" : ["Reverse", ""],
	"boost" : ["Boost", ""],
	"drift" : ["Drift", ""],
}

#Reset after exit.
var match_duration = 180
var time_limit = 180
var counter_time = 3

var counter_time_left = "0"
var time_left = "00:00.000"

var is_counting_down = true
var zooming_enabled = true
var stop_engines = false

var match_settings = {
	"team_color" : "",
	"car_resource": ""
}

var input_menu_parent = ""
var settings_menu_parent = ""

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

var master_volume = 10
var sfx_volume = 10
var music_volume = 10

var starting_positions = {
	0 : Vector2(-128, 480),
	1 : Vector2(128, 480),
	2 : Vector2(0, 480)
}

var settings_file

func _process(delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(range_lerp(master_volume, 0, 10, 0, 1)))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(range_lerp(sfx_volume, 0, 10, 0, 1)))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(range_lerp(music_volume, 0, 10, 0, 1)))

	
func _ready():
#	save_settings()
	load_settings()

func reset_essentials():
	time_limit = match_duration
	counter_time = 3
	is_counting_down = true
	stop_engines = false
	
	counter_time_left = "0"
	time_left = "00:00.000"
	
	score["red"] = 0
	score["blue"] = 0

func save_settings():
	for action in InputMap.get_actions():
		if action in binds:
			settings_file.binds[action] = InputMap.get_action_list(action)
	
	settings_file.master_volume = master_volume
	settings_file.sfx_volume = sfx_volume
	settings_file.music_volume = music_volume
	
	ResourceSaver.save("user://settings_save_file.tres", settings_file)
	
func load_settings():
	settings_file = load("user://settings_save_file.tres")
	
	if not settings_file:
		settings_file = settings_save_resource.new()
		save_settings()
	
	for action in settings_file.binds:
		InputMap.action_erase_events(action)
		for input_event in settings_file.binds[action]:
			InputMap.action_add_event(action, input_event)
	
	master_volume = settings_file.master_volume
	sfx_volume = settings_file.sfx_volume
	music_volume = settings_file.music_volume
	
	
