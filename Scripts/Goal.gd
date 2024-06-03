extends Area2D


onready var sprite = $"%Sprite"
export(String, "red", "blue") var team_color

func _ready():
	if team_color == "blue":
		sprite.frame = 0
	elif team_color == "red":
		sprite.frame = 1
