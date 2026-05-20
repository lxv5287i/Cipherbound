extends Node

@export var correct_sound: AudioStream
@export var wrong_sound: AudioStream
@export var volume := -15.0
@export var stop_after := 3.0

@onready var correct_sfx: AudioStreamPlayer = $CorrectSFX
@onready var wrong_sfx: AudioStreamPlayer = $WrongSFX


func _ready():

	# extra safety
	correct_sfx.autoplay = false
	wrong_sfx.autoplay = false

	correct_sfx.stream = correct_sound
	wrong_sfx.stream = wrong_sound

	correct_sfx.volume_db = volume
	wrong_sfx.volume_db = volume

	correct_sfx.stop()
	wrong_sfx.stop()


func play_correct():

	if correct_sfx.playing:
		correct_sfx.stop()

	if wrong_sfx.playing:
		wrong_sfx.stop()

	correct_sfx.play()

	await get_tree().create_timer(stop_after).timeout

	if correct_sfx.playing:
		correct_sfx.stop()


func play_wrong():
	if correct_sfx.playing:
		correct_sfx.stop()
	if wrong_sfx.playing:
		wrong_sfx.stop()

	wrong_sfx.play()

	await get_tree().create_timer(stop_after).timeout

	if wrong_sfx.playing:
		wrong_sfx.stop()
