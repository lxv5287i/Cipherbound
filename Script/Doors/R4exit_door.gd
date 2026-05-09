extends Area2D

@export var closed_texture: Texture2D
@export var closed_inrange_texture: Texture2D
@export var open_texture: Texture2D
@export var open_inrange_texture: Texture2D

@export var locked_text := "[LOCKED]"
@export var waiting_text := "[WAITING]"
@export var open_text := "[OPEN]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var door_open := false
var coder_in_range := false
var analyst_in_range := false
var transferring := false


func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	label.visible = false

	if closed_texture:
		sprite.texture = closed_texture

	if GameProgress.has_signal("room4_both_done"):
		if not GameProgress.room4_both_done.is_connected(open_door):
			GameProgress.room4_both_done.connect(open_door)

	if GameProgress.room4_done_signal_sent:
		open_door()


func open_door():
	door_open = true

	if open_texture:
		sprite.texture = open_texture

	print("Room 4 exit door opened")
	update_state()


func _on_body_entered(body):
	if transferring:
		return

	if body.name == "CoderPlayer":
		coder_in_range = true

	if body.name == "AnalystPlayer":
		analyst_in_range = true

	update_state()


func _on_body_exited(body):
	if body.name == "CoderPlayer":
		coder_in_range = false

	if body.name == "AnalystPlayer":
		analyst_in_range = false

	update_state()


func update_state():
	if transferring:
		return

	var any_inside := coder_in_range or analyst_in_range
	var both_inside := coder_in_range and analyst_in_range

	if not any_inside:
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

	if both_inside:
		label.text = open_text

		if open_inrange_texture:
			sprite.texture = open_inrange_texture
		elif open_texture:
			sprite.texture = open_texture

		transferring = true

		GameProgress.unlock_only_room5()

		var main = get_tree().get_first_node_in_group("split_screen_main")
		if main:
			main.call_deferred("go_to_lobby")
		else:
			print("ERROR: SplitScreenMain or go_to_lobby not found")

		return

	label.text = waiting_text

	if open_inrange_texture:
		sprite.texture = open_inrange_texture
	elif open_texture:
		sprite.texture = open_texture
