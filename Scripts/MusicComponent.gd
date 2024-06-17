extends Node2D


onready var lead_1 = $"%Lead1"
onready var lead_2 = $"%Lead2"

onready var bass = $"%Bass"
onready var drums = $"%Drums"

onready var metronome = $"%Metronome"

var game_is_active = false

var tempo = 160

var beat = 0
var bar = 1
var time_elapsed = 0.0

func _ready():
	metronome.wait_time = 60.0 / tempo
	
	drums.play()
	lead_1.play()
	lead_2.play()
	bass.play()
	
	
func _process(delta):
	pass
#	if bar == 2 and beat == 1 and !drums.playing:
#		drums.play()
#
#	if bar == 6 and beat == 1 and !bass.playing:
#		bass.play()

#	if bar == 10 and beat == 1 and !lead_2.playing and !game_is_active:
#		lead_2.play()
#
#	if fmod(bar, 4) == 0 and beat == 1 and game_is_active and !lead_1.playing:
#		lead_2.stop()
#		lead_1.play()
#
#	if fmod(bar, 4) == 0 and beat == 1 and !game_is_active:
#		lead_1.stop()
		
func _on_Metronome_timeout():
	if beat < 4:
		beat += 1
	else:
		beat = 1
		if bar == 32:
			bar = 1
		else:
			bar += 1
