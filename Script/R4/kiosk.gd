extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var changed_texture: Texture2D
@export var changed_inrange_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = $"../KioskPopup"

var unlocked := false
var player_inside := false
var interacted := false


func _ready():
	add_to_group("analyst_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	prompt_label.visible = false
	prompt_label.text = "[LOCKED]"


func unlock_kiosk():
	unlocked = true
	print("Kiosk unlocked")

	if player_inside:
		prompt_label.visible = true

		if interacted:
			prompt_label.text = "[OPENED]"

			if changed_inrange_texture:
				sprite.texture = changed_inrange_texture
			elif changed_texture:
				sprite.texture = changed_texture
		else:
			prompt_label.text = "[SPACE]"

			if inrange_texture:
				sprite.texture = inrange_texture


func show_prompt():
	player_inside = true
	prompt_label.visible = true

	if interacted:
		prompt_label.text = "[OPENED]"

		if changed_inrange_texture:
			sprite.texture = changed_inrange_texture
		elif changed_texture:
			sprite.texture = changed_texture

		return

	if unlocked:
		prompt_label.text = "[SPACE]"

		if inrange_texture:
			sprite.texture = inrange_texture
	else:
		prompt_label.text = "[LOCKED]"

		if normal_texture:
			sprite.texture = normal_texture


func hide_prompt():
	player_inside = false
	prompt_label.visible = false

	if interacted:
		if changed_texture:
			sprite.texture = changed_texture
	else:
		if normal_texture:
			sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()


func interact(_player = null):
	if not unlocked:
		prompt_label.visible = true
		prompt_label.text = "[LOCKED]"
		return

	if not interacted:
		interacted = true

		var progress = get_tree().get_first_node_in_group("game_progress")
		print("Kiosk found progress:", progress)

		if progress and progress.has_method("room4_analyst_opened_interactable"):
			progress.room4_analyst_opened_interactable()

	if player_inside:
		prompt_label.visible = true
		prompt_label.text = "[OPENED]"

		if changed_inrange_texture:
			sprite.texture = changed_inrange_texture
		elif changed_texture:
			sprite.texture = changed_texture
	else:
		if changed_texture:
			sprite.texture = changed_texture

	if popup and popup.has_method("open_popup"):
		popup.open_popup()
