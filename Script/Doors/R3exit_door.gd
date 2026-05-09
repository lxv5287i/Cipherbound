extends Area2D

@export var closed_texture: Texture2D
@export var closed_inrange_texture: Texture2D
@export var open_texture: Texture2D
@export var open_inrange_texture: Texture2D

@export var locked_text: String = "[LOCKED]"
@export var waiting_text: String = "[WAITING]"
@export var open_text: String = "[OPEN]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var door_open := false
var transferring := false
var coder_in_range := false
var analyst_in_range := false


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	label.visible = false

	if closed_texture:
		sprite.texture = closed_texture

	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		if not progress.both_solved.is_connected(open_door):
			progress.both_solved.connect(open_door)


func open_door():
	door_open = true

	if open_texture:
		sprite.texture = open_texture

	print("Room 3 exit door opened")


func _on_body_entered(body):
	if transferring:
		return

	if body.name == "CoderPlayer":
		coder_in_range = true

	if body.name == "AnalystPlayer":
		analyst_in_range = true

	update_door_state()


func _on_body_exited(body):
	if body.name == "CoderPlayer":
		coder_in_range = false

	if body.name == "AnalystPlayer":
		analyst_in_range = false

	update_door_state()


func update_door_state():
	if transferring:
		return

	if not coder_in_range and not analyst_in_range:
		label.visible = false

		if door_open:
			if open_texture:
				sprite.texture = open_texture
		else:
			if closed_texture:
				sprite.texture = closed_texture

		return

	label.visible = true

	if not door_open:
		label.text = locked_text

		if closed_inrange_texture:
			sprite.texture = closed_inrange_texture

		return

	if coder_in_range and analyst_in_range:
		label.text = open_text

		if open_inrange_texture:
			sprite.texture = open_inrange_texture

		transferring = true

		var progress = get_tree().get_first_node_in_group("game_progress")
		if progress:
			progress.unlock_only_room4()

		var main = get_tree().get_first_node_in_group("split_screen_main")
		if main:
			main.call_deferred("go_to_lobby")

		return

	label.text = waiting_text

	if open_inrange_texture:
		sprite.texture = open_inrange_texture
