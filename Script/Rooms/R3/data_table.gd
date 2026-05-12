extends Area2D

@export var starts_unlocked := false

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D

@export var popup_path: NodePath
@export var unlock_target_path: NodePath

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = get_node_or_null(popup_path)
@onready var unlock_target: Area2D = get_node_or_null(unlock_target_path) as Area2D

var unlocked := false

func _ready():
	add_to_group("analyst_interactable")

	unlocked = starts_unlocked

	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	update_prompt()

func show_prompt():
	prompt_label.visible = true
	update_prompt()

	if unlocked and inrange_texture:
		sprite.texture = inrange_texture
	elif normal_texture:
		sprite.texture = normal_texture

func hide_prompt():
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()

func interact(_player = null):
	if not unlocked:
		prompt_label.visible = true
		prompt_label.text = "[LOCKED]"
		return

	if popup and popup.has_method("open_popup"):
		popup.open_popup()

	if unlock_target and unlock_target.has_method("unlock_table"):
		unlock_target.unlock_table()

func unlock_table():
	unlocked = true
	update_prompt()

func update_prompt():
	if unlocked:
		prompt_label.text = "[SPACE]"
	else:
		prompt_label.text = "[LOCKED]"
		
