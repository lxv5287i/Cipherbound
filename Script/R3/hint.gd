extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var prompt_text := "[Hint]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = $"../HintPopup"

func _ready():
	add_to_group("analyst_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	prompt_label.visible = false
	prompt_label.text = prompt_text

func show_prompt():
	prompt_label.visible = true
	prompt_label.text = prompt_text

	if inrange_texture:
		sprite.texture = inrange_texture

func hide_prompt():
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()

func interact(_player = null):
	if popup and popup.has_method("open_popup"):
		popup.open_popup()
