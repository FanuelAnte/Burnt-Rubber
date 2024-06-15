extends Node2D


onready var accept = $"%Accept"
onready var back = $"%Back"
onready var navigate = $"%Navigate"

func _ready():
	pass

func play_accept():
	accept.play()
	
func play_back():
	back.play()
	
func play_navigate():
	navigate.play()
