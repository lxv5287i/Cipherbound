extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var solved_texture: Texture2D
@export var solved_inrange_texture: Texture2D

@export var locked_text: String = "[LOCKED]"
@export var interact_text: String = "PRESS [E]"
@export var solved_text: String = "[EXPLANATION]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label
@onready var popup: CanvasLayer = $"../SciCompPopup"

var unlocked := false
var solved := false
var player_inside := false


func _ready():
	add_to_group("coder_interactable")

	prompt_label.visible = false
	prompt_label.text = locked_text

	if normal_texture:
		sprite.texture = normal_texture

	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress:
		unlocked = progress.is_room4_coder_unlocked()

		if progress.has_signal("room4_analyst_interactables_done"):
			if not progress.room4_analyst_interactables_done.is_connected(_on_room4_analyst_done):
				progress.room4_analyst_interactables_done.connect(_on_room4_analyst_done)

	if popup and popup.has_signal("puzzle_correct"):
		if not popup.puzzle_correct.is_connected(_on_puzzle_correct):
			popup.puzzle_correct.connect(_on_puzzle_correct)


func _on_room4_analyst_done():
	unlocked = true
	print("SciComp unlocked")

	if player_inside:
		prompt_label.visible = true
		prompt_label.text = interact_text

		if inrange_texture:
			sprite.texture = inrange_texture


func check_unlock():
	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress and progress.has_method("is_room4_coder_unlocked"):
		unlocked = progress.is_room4_coder_unlocked()


func show_prompt():
	check_unlock()

	player_inside = true
	prompt_label.visible = true

	if solved:
		prompt_label.text = solved_text

		if solved_inrange_texture:
			sprite.texture = solved_inrange_texture
		elif solved_texture:
			sprite.texture = solved_texture

		return

	if unlocked:
		prompt_label.text = interact_text
	else:
		prompt_label.text = locked_text

	if inrange_texture:
		sprite.texture = inrange_texture


func hide_prompt():
	player_inside = false
	prompt_label.visible = false

	if solved:
		if solved_texture:
			sprite.texture = solved_texture
	else:
		if normal_texture:
			sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()


func interact(_player = null):
	check_unlock()

	if solved:
		if popup and popup.has_method("open_explanation_only"):
			popup.open_explanation_only()
		return

	if not unlocked:
		prompt_label.visible = true
		prompt_label.text = locked_text
		print("SciComp locked. Analyst must open both interactables first.")
		return

	if popup and popup.has_method("open_popup"):
		popup.open_popup()


func _on_puzzle_correct():
	solved = true
	unlocked = true
	prompt_label.visible = false

	if solved_texture:
		sprite.texture = solved_texture

	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress and progress.has_method("solve_room4_coder"):
		progress.solve_room4_coder()
