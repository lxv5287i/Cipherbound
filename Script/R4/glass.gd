extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var changed_texture: Texture2D
@export var changed_inrange_texture: Texture2D
@export var unlock_target_path: NodePath

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = $"../HoloPopup"
@onready var unlock_target: Area2D = get_node_or_null(unlock_target_path) as Area2D

var changed := false
var player_inside := false


func _ready():
	add_to_group("analyst_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	prompt_label.visible = false
	prompt_label.text = "[SPACE]"


func show_prompt():
	player_inside = true
	prompt_label.visible = true

	if changed:
		prompt_label.text = "[OPENED]"

		if changed_inrange_texture:
			sprite.texture = changed_inrange_texture
		elif changed_texture:
			sprite.texture = changed_texture

		return

	prompt_label.text = "[BROKEN]"

	if inrange_texture:
		sprite.texture = inrange_texture
	elif normal_texture:
		sprite.texture = normal_texture


func hide_prompt():
	player_inside = false
	prompt_label.visible = false

	if changed:
		if changed_texture:
			sprite.texture = changed_texture
	else:
		if normal_texture:
			sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()


func interact(_player = null):
	if not changed:
		changed = true

		var progress = get_tree().get_first_node_in_group("game_progress")
		print("Glass found progress:", progress)

		if progress and progress.has_method("room4_analyst_opened_interactable"):
			progress.room4_analyst_opened_interactable()

		if unlock_target and unlock_target.has_method("unlock_kiosk"):
			unlock_target.unlock_kiosk()

	if player_inside:
		prompt_label.visible = true
		prompt_label.text = "[FIXED]"

		if changed_inrange_texture:
			sprite.texture = changed_inrange_texture
		elif changed_texture:
			sprite.texture = changed_texture
	else:
		if changed_texture:
			sprite.texture = changed_texture

	if popup and popup.has_method("open_popup"):
		popup.open_popup()
