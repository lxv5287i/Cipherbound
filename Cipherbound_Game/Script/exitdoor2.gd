extends Area2D

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var game_progress = get_tree().root.get_node("SplitScreenMain/GameProgress")

var door_open := false
var player_near := false

func _ready():
	label.visible = false
	game_progress.both_solved.connect(open_door)

func open_door():
	if door_open:
		return

	print("Door opened")
	door_open = true
	anim.play("open")

func _on_body_entered(body):
	if body.name == "AnalystPlayer" or body.name == "CoderPlayer":
		player_near = true
		update_label()

		if door_open:
			get_tree().root.get_node("SplitScreenMain").go_to_room3()

func _on_body_exited(body):
	if body.name == "AnalystPlayer" or body.name == "CoderPlayer":
		player_near = false
		label.visible = false

func update_label():
	label.visible = true

	if door_open:
		label.text = "Open"
	else:
		label.text = "Locked"
