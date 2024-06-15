extends Position2D


onready var sprite = $"%Sprite"

func _ready():
	if get_parent().is_player:
		sprite.show()
	else:
		sprite.hide()
		
func _physics_process(_delta):
	if get_parent().is_player:
		self.look_at(get_tree().get_nodes_in_group("puck")[0].global_position)
#		rotation_degrees = stepify(rotation_degrees, 5)
