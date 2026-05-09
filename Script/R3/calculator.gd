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
@onready var popup: CanvasLayer = $"../CalculatorPopup"

var solved := false
var unlocked := false
var player_inside := false


func _ready():
	add_to_group("coder_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	prompt_label.visible = false
	prompt_label.text = locked_text

	if popup and popup.has_signal("puzzle_correct"):
		if not popup.puzzle_correct.is_connected(_on_puzzle_correct):
			popup.puzzle_correct.connect(_on_puzzle_correct)

	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress:
		unlocked = progress.is_analyst_solved()

		if progress.has_signal("analyst_solved"):
			if not progress.analyst_solved.is_connected(_on_analyst_solved):
				progress.analyst_solved.connect(_on_analyst_solved)


func _on_analyst_solved():
	unlocked = true

	print("Calculator unlocked.")

	if player_inside:
		prompt_label.visible = true
		prompt_label.text = interact_text

		if inrange_texture:
			sprite.texture = inrange_texture
	else:
		if normal_texture:
			sprite.texture = normal_texture


func show_prompt():
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
	if solved:
		if popup and popup.has_method("open_explanation_only"):
			popup.open_explanation_only()
		return

	if not unlocked:
		prompt_label.visible = true
		prompt_label.text = locked_text

		print("Calculator locked.")
		return

	if popup and popup.has_method("open_popup"):
		popup.open_popup()
	else:
		print("Calculator popup missing.")


func _on_puzzle_correct():
	solved = true
	unlocked = true

	prompt_label.visible = false

	if solved_texture:
		sprite.texture = solved_texture

	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress and progress.has_method("solve_coder"):
		progress.solve_coder()
