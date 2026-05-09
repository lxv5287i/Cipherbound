extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D

@onready var prompt_label: Label = $Label
@onready var hint_popup: CanvasLayer = $"../HintPopup"
@onready var sprite: Sprite2D = $Sprite2D

var popup_open := false

func _ready():
	add_to_group("analyst_interactable")

	prompt_label.text = "[Space]"
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	if hint_popup and hint_popup.has_method("close_popup"):
		hint_popup.close_popup()

func show_prompt():
	prompt_label.visible = true

	if inrange_texture:
		sprite.texture = inrange_texture

func hide_prompt():
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	close_popup()

func interact(_player = null):
	if popup_open:
		close_popup()
	else:
		open_popup()

func open_popup():
	popup_open = true

	if hint_popup and hint_popup.has_method("open_popup"):
		hint_popup.open_popup()

func close_popup():
	popup_open = false

	if hint_popup and hint_popup.has_method("close_popup"):
		hint_popup.close_popup()
