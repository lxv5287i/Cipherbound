extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D
@export var solved_texture: Texture2D
@export var inrange_solved_texture: Texture2D

@export var locked_text: String = "[LOCKED]"
@export var interact_text: String = "PRESS [E]"
@export var solved_text: String = "[EXPLANATION]"

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var popup: CanvasLayer = $"../CoderPuzzlePopup"

var unlocked := false
var solved := false


func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	if popup and popup.has_signal("puzzle_correct"):
		if not popup.puzzle_correct.is_connected(_on_puzzle_correct):
			popup.puzzle_correct.connect(_on_puzzle_correct)

	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress:
		unlocked = progress.is_coder_unlocked()

		if progress.has_signal("analyst_solved"):
			if not progress.analyst_solved.is_connected(unlock):
				progress.analyst_solved.connect(unlock)
	else:
		print("ERROR: GameProgress not found")


func unlock():
	unlocked = true
	print(name, " unlocked")

	if label.visible:
		label.text = interact_text

	if inrange_texture:
		sprite.texture = inrange_texture


func solve():
	solved = true
	unlocked = true

	if solved_texture:
		sprite.texture = solved_texture

	label.visible = false
	print(name, " solved")


func interact(_player = null):
	if not unlocked:
		label.visible = true
		label.text = locked_text
		print("Locked. Analyst must solve first.")
		return

	if solved:
		if popup and popup.has_method("open_explanation_only"):
			popup.open_explanation_only()
		return

	if popup and popup.has_method("open_popup"):
		popup.open_popup()
	else:
		print("ERROR: CoderPuzzlePopup not found or missing open_popup()")


func _on_puzzle_correct():
	solve()

	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress and progress.has_method("solve_coder"):
		progress.solve_coder()
	else:
		print("ERROR: Cannot call solve_coder()")


func _on_body_entered(body):
	if body.name != "CoderPlayer" and body.name != "AnalystPlayer":
		return

	label.visible = true

	if solved:
		label.text = solved_text

		if inrange_solved_texture:
			sprite.texture = inrange_solved_texture

		return

	if unlocked:
		label.text = interact_text
	else:
		label.text = locked_text

	if inrange_texture:
		sprite.texture = inrange_texture


func _on_body_exited(body):
	if body.name != "CoderPlayer" and body.name != "AnalystPlayer":
		return

	label.visible = false

	if solved:
		if solved_texture:
			sprite.texture = solved_texture
	else:
		if normal_texture:
			sprite.texture = normal_texture

	if popup and popup.has_method("close_popup"):
		popup.close_popup()
