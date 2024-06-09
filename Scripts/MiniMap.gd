extends MarginContainer


onready var red_team_icon = $"%RedTeamIcon"
onready var red_team_player_icon = $"%RedTeamPlayerIcon"
onready var blue_team_icon = $"%BlueTeamIcon"
onready var blue_team_player_icon = $"%BlueTeamPlayerIcon"
onready var puck_icon = $"%PuckIcon"

onready var grid = $"%Grid"
onready var icons_controller = $"%Icons"

export var zoom = 10

onready var icons = {
	"red_team": red_team_icon, 
	"red_team_player": red_team_player_icon,
	"blue_team": blue_team_icon, 
	"blue_team_player": blue_team_player_icon, 
	"puck": puck_icon
}

var grid_scale
var markers = {}

func _ready():
	update_objects_list()
	
func update_objects_list():
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for icon in icons_controller.get_children():
		icon.queue_free()
	
	for object in map_objects:
		#TODO: Add 2 more icons for red ad blue to signify the player.
		if object.is_in_group("cars"):
			if object.team_color == "red":
				var new_marker
				if object.is_player:
					new_marker = icons["red_team_player"].duplicate()
				else:
					new_marker = icons["red_team"].duplicate()
					
				icons_controller.add_child(new_marker)
				new_marker.show()
				markers[object] = new_marker
			elif object.team_color == "blue":
				var new_marker
				if object.is_player:
					new_marker = icons["blue_team_player"].duplicate()
				else:
					new_marker = icons["blue_team"].duplicate()
					
				icons_controller.add_child(new_marker)
				new_marker.show()
				markers[object] = new_marker
		elif object.is_in_group("puck"):
			var new_marker = icons["puck"].duplicate()
			icons_controller.add_child(new_marker)
			new_marker.show()
			markers[object] = new_marker
		
func _process(delta):
	for marker in markers:
		var object_position = marker.position / 16 + Vector2(16, 32)
		object_position.x = clamp(object_position.x, 1, grid.rect_size.x - 1)
		object_position.y = clamp(object_position.y, 1, grid.rect_size.y - 1)
		markers[marker].position = object_position
