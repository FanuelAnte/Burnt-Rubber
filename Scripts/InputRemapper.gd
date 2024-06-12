extends HBoxContainer


onready var action_name_lbl = $"%ActionNameLbl"
onready var action_bind_lbl = $"%ActionBindLbl"

#export (int, 0, 5) var action_name_index

var binds = {
	"Forward" : "Z",
	"Reverse" : "X",
	"Steer Left-Menu Left" : "Left",
	"Steer Right-Menu RIght" : "Right",
	"Boost-Menu Up" : "Up",
	"Drift-Menu Donw" : "Down",
	"Accept" : "Enter",
	"Pause-Back" : "Escape"
}

func _ready():
	var index = get_parent().get_node(self.name).get_index()
	
	action_name_lbl.text = binds.keys()[index]
	action_bind_lbl.text = binds.values()[index]
	
func _process(delta):
	pass
