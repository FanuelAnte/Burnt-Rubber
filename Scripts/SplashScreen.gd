extends Control


onready var anim_player = $"%AnimPlayer"

func _ready():
	anim_player.play("fade")

func _on_AnimPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
