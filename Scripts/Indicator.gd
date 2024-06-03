extends Position2D


func _physics_process(delta):
	self.look_at(get_tree().get_nodes_in_group("puck")[0].global_position)
