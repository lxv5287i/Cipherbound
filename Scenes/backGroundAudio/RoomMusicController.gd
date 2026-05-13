extends Node

@export var music: AudioStream
@export var target_volume := -15.0
@export var fade_time := 3.0
@export var start_volume := -30.0

func _ready():
	if music == null:
		return

	if MusicManager.stream != music:
		MusicManager.stream = music
		MusicManager.volume_db = start_volume
		MusicManager.play()

		var tween = create_tween()
		tween.tween_property(MusicManager, "volume_db", target_volume, fade_time)
