extends Area2D

@export var off_texture: Texture2D
@export var off_inrange_texture: Texture2D
@export var on_texture: Texture2D
@export var on_inrange_texture: Texture2D

@export var target_computer_path: NodePath
@export var switch_id := ""

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var target_computer: Node = get_node_or_null(target_computer_path)

var is_on := false
var player_inside := false

func _ready():
	add_to_group("coder_interactable")

	label.visible = true
	label.text = ""

	if off_texture:
		sprite.texture = off_texture

func show_prompt():
	player_inside = true
	label.visible = true
	label.text = "[TurnON]"

	if is_on:
		if on_inrange_texture:
			sprite.texture = on_inrange_texture
			label.text = "[TurnOFF]"
	else:
		if off_inrange_texture:
			sprite.texture = off_inrange_texture

func hide_prompt():
	player_inside = false
	label.visible = false

	if is_on:
		if on_texture:
			sprite.texture = on_texture
	else:
		if off_texture:
			sprite.texture = off_texture

func interact(_player = null):
	is_on = !is_on
	update_texture()

	if target_computer:
		if is_on and target_computer.has_method("turn_on"):
			target_computer.turn_on()
		elif not is_on and target_computer.has_method("turn_off"):
			target_computer.turn_off()

	print("Switch ", switch_id, " is now ", "ON" if is_on else "OFF")

func update_texture():
	if player_inside:
		if is_on and on_inrange_texture:
			sprite.texture = on_inrange_texture
		elif not is_on and off_inrange_texture:
			sprite.texture = off_inrange_texture
	else:
		if is_on and on_texture:
			sprite.texture = on_texture
		elif not is_on and off_texture:
			sprite.texture = off_texture
