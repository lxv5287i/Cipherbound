extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var solved_texture: Texture2D
@export var solved_inrange_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $PromptLabel
@onready var popup: CanvasLayer = $AnalystPuzzlePopup

var solved := false

func _ready():
	add_to_group("analyst_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	prompt_label.visible = false
	prompt_label.text = "[Space]"

	if popup and popup.has_signal("puzzle_correct"):
		popup.puzzle_correct.connect(_on_puzzle_correct)

func show_range():
	prompt_label.visible = true

	if solved:
		if solved_inrange_texture:
			sprite.texture = solved_inrange_texture
		elif inrange_texture:
			sprite.texture = inrange_texture

		prompt_label.text = "Explanation"
		return

	if inrange_texture:
		sprite.texture = inrange_texture

	prompt_label.text = "[Space]"

func hide_range():
	prompt_label.visible = false

	if solved:
		if solved_texture:
			sprite.texture = solved_texture
		elif normal_texture:
			sprite.texture = normal_texture

		if popup and popup.has_method("close_popup"):
			popup.close_popup()

		return

	if normal_texture:
		sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()

func show_prompt():
	show_range()

func hide_prompt():
	hide_range()

func interact(_player = null):
	if solved:
		if popup and popup.has_method("open_explanation_only"):
			popup.open_explanation_only()
		return

	if popup and popup.has_method("open_popup"):
		popup.open_popup()

func _on_puzzle_correct():
	solved = true

	if solved_texture:
		sprite.texture = solved_texture

	prompt_label.visible = false

	var progress = get_tree().get_first_node_in_group("game_progress")
	if progress and progress.has_method("solve_analyst"):
		progress.solve_analyst()
