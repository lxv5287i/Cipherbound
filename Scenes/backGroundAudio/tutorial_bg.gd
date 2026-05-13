extends AudioStreamPlayer

@onready var tutorial_music: AudioStreamPlayer = $"."

var robot_done := false
var analyst_done := false
var coder_done := false


func _ready():
	add_to_group("tutorial_level")

	tutorial_music.volume_db = -40

	if not tutorial_music.playing:
		tutorial_music.play()

	var fade_in = create_tween()
	fade_in.tween_property(tutorial_music, "volume_db", -15, 2.0)


func unlock_analyst():
	robot_done = true


func solve_analyst():
	analyst_done = true


func solve_coder():
	coder_done = true


func fade_out_music():
	var fade_out = create_tween()
	fade_out.tween_property(tutorial_music, "volume_db", -40, 2.0)

	await fade_out.finished

	tutorial_music.stop()
