extends Node

@export var correct_sound: AudioStream
@export var wrong_sound: AudioStream
@export var volume := -10.0
@export var stop_after := 2.0

@onready var correct_sfx: AudioStreamPlayer = $CorrectSFX
@onready var wrong_sfx: AudioStreamPlayer = $WrongSFX


func _ready():
	correct_sfx.autoplay = false
	wrong_sfx.autoplay = false

	correct_sfx.stop()
	wrong_sfx.stop()

	correct_sfx.volume_db = volume
	wrong_sfx.volume_db = volume

	correct_sfx.stream = correct_sound
	wrong_sfx.stream = wrong_sound


func play_correct():
	wrong_sfx.stop()
	correct_sfx.stop()

	correct_sfx.play()

	await get_tree().create_timer(stop_after).timeout
	correct_sfx.stop()


func play_wrong():
	correct_sfx.stop()
	wrong_sfx.stop()

	wrong_sfx.play()

	await get_tree().create_timer(stop_after).timeout
	wrong_sfx.stop()
