extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export_multiline var popup_text := ""
@export var popup_path: NodePath

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var popup: CanvasLayer = get_node_or_null(popup_path)

func _ready():
	add_to_group("analyst_interactable")
	add_to_group("coder_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	label.visible = false
	label.text = "[INTERACT]"

func show_prompt():
	label.visible = true
	label.text = "[INTERACT]"

	if inrange_texture:
		sprite.texture = inrange_texture

func hide_prompt():
	label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()

func interact(_player = null):
	if popup and popup.has_method("open_popup"):
		popup.open_popup(popup_text)
