extends Area2D

@export var closed_texture: Texture2D
@export var closed_inrange_texture: Texture2D
@export var open_texture: Texture2D
@export var open_inrange_texture: Texture2D

@export var locked_text: String = "[LOCKED]"
@export var waiting_text: String = "[WAITING]"
@export var interact_text: String = "[INTERACT]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var coder_in_range := false
var analyst_in_range := false
var transferring := false


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	label.visible = false
	update_texture(false)


func is_unlocked() -> bool:
	var progress = get_tree().get_first_node_in_group("game_progress")
	return progress and progress.room3_unlocked


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

	var any_inside = coder_in_range or analyst_in_range
	var both_inside = coder_in_range and analyst_in_range

	if not any_inside:
		label.visible = false
		update_texture(false)
		return

	label.visible = true

	if not is_unlocked():
		label.text = locked_text
		update_texture(true)
		return

	if both_inside:
		label.text = interact_text
		update_texture(true)

		transferring = true

		var main = get_tree().get_first_node_in_group("split_screen_main")
		if main:
			main.call_deferred("go_to_room3")

		return

	label.text = waiting_text
	update_texture(true)


func update_texture(in_range: bool):
	if is_unlocked():
		if in_range:
			if open_inrange_texture:
				sprite.texture = open_inrange_texture
		else:
			if closed_texture:
				sprite.texture = closed_texture
	else:
		if in_range:
			if closed_inrange_texture:
				sprite.texture = closed_inrange_texture
		else:
			if closed_texture:
				sprite.texture = closed_texture
