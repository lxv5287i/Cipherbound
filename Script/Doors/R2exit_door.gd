extends Area2D

@export var closed_texture: Texture2D
@export var closed_inrange_texture: Texture2D
@export var open_texture: Texture2D
@export var open_inrange_texture: Texture2D

@export var locked_text: String = "[LOCKED]"
@export var open_text: String = "[OPEN]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var door_open := false
var player_in_range := false


func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	label.visible = false

	if closed_texture:
		sprite.texture = closed_texture

	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress:
		if not progress.both_solved.is_connected(open_door):
			progress.both_solved.connect(open_door)

		if progress.is_analyst_solved() and progress.is_coder_solved():
			open_door()


func open_door():
	door_open = true

	if player_in_range:
		if open_inrange_texture:
			sprite.texture = open_inrange_texture

		label.visible = true
		label.text = open_text
	else:
		if open_texture:
			sprite.texture = open_texture

	print(name, " opened")


func _on_body_entered(body):
	if body.name != "CoderPlayer" and body.name != "AnalystPlayer":
		return

	player_in_range = true
	label.visible = true

	if door_open:
		label.text = open_text

		if open_inrange_texture:
			sprite.texture = open_inrange_texture

		var progress = get_tree().get_first_node_in_group("game_progress")
		if progress:
			progress.set_player_at_exit(body.name, true)
	else:
		label.text = locked_text

		if closed_inrange_texture:
			sprite.texture = closed_inrange_texture


func _on_body_exited(body):
	if body.name != "CoderPlayer" and body.name != "AnalystPlayer":
		return

	player_in_range = false
	label.visible = false

	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		progress.set_player_at_exit(body.name, false)

	if door_open:
		if open_texture:
			sprite.texture = open_texture
	else:
		if closed_texture:
			sprite.texture = closed_texture
