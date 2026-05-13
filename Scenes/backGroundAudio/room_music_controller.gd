extends Node

@export var room_music: AudioStream


func _ready():
	print("ROOM READY:", name)

	await get_tree().process_frame

	if room_music:
		MusicManager.play_music(room_music)
	else:
		print("NO MUSIC ASSIGNED IN:", name)
