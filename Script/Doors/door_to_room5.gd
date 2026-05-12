extends Area2D

@export var closed_texture: Texture2D
@export var closed_inrange_texture: Texture2D
@export var open_texture: Texture2D
@export var open_inrange_texture: Texture2D

@export var locked_text := "[LOCKED]"
@export var waiting_text := "[WAITING]"
@export var interact_text := "[INTERACT]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var coder_in_range := false
var analyst_in_range := false
var transferring := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	label.visible = false
	if closed_texture:
		sprite.texture = closed_texture

func is_unlocked() -> bool:
	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress:
		return progress.room5_unlocked
	return false

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
		if closed_texture:
			sprite.texture = closed_texture
		return
	label.visible = true
	if not is_unlocked():
		label.text = locked_text
		if closed_inrange_texture:
			sprite.texture = closed_inrange_texture
		return
	if both_inside:
		label.text = interact_text
		if open_inrange_texture:
			sprite.texture = open_inrange_texture
		elif open_texture:
			sprite.texture = open_texture
		transferring = true
		LoadingScreen.show_overlay()
		var main = get_tree().get_first_node_in_group("split_screen_main")
		if main:
			main.call_deferred("go_to_room5")
		return
	label.text = waiting_text
	if open_inrange_texture:
		sprite.texture = open_inrange_texture
	elif open_texture:
		sprite.texture = open_texture
