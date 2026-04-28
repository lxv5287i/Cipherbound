extends Area2D

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $AnimationPlayer

var game_progress = null
var main_scene = null

var door_open := false
var player_near := false

func _ready():
	label.visible = false

	game_progress = get_tree().get_first_node_in_group("game_progress")
	main_scene = get_tree().get_first_node_in_group("split_screen_main")

	if game_progress == null:
		push_error("GameProgress not found. Add GameProgress to group: game_progress")
		return

	if main_scene == null:
		push_error("SplitScreenMain not found. Add root node to group: split_screen_main")
		return

	if game_progress.has_signal("both_solved"):
		game_progress.both_solved.connect(open_door)
	else:
		push_error("GameProgress has no signal named both_solved")

func open_door():
	if door_open:
		return

	print("Door opened")
	door_open = true
	anim.play("open")

func _on_body_entered(body):
	if body.is_in_group("analyst_player") or body.is_in_group("coder_player"):
		player_near = true
		update_label()

		if door_open and main_scene and main_scene.has_method("go_to_room3"):
			main_scene.call_deferred("go_to_room3")

func _on_body_exited(body):
	if body.is_in_group("analyst_player") or body.is_in_group("coder_player"):
		player_near = false
		label.visible = false

func update_label():
	label.visible = true

	if door_open:
		label.text = "Open"
	else:
		label.text = "Locked"
