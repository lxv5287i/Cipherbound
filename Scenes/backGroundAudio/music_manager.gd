extends AudioStreamPlayer

var current_music: AudioStream = null
var is_switching := false


func _ready():
	volume_db = -50


func play_music(music: AudioStream, fade := 1.5):

	if music == null:
		print("MusicManager: NULL music received")
		return

	# Prevent spam / overlap from multiple rooms
	if is_switching:
		return

	# Same track already playing
	if current_music == music and playing:
		return

	is_switching = true
	current_music = music

	print("MusicManager: Switching to -> ", music)

	# Fade out current music
	if playing:
		var fade_out = create_tween()

		fade_out.tween_property(self, "volume_db", -40, fade / 2)
		await fade_out.finished

	stop()

	# Start new music
	stream = music
	play()

	volume_db = -40

	# Fade in
	var fade_in = create_tween()
	fade_in.tween_property(self, "volume_db", -15, fade / 2)

	await fade_in.finished

	is_switching = false


func stop_music(fade := 1.0):

	if not playing:
		return

	is_switching = true

	var tween = create_tween()
	tween.tween_property(self, "volume_db", -40, fade)

	await tween.finished

	stop()
	is_switching = false
