extends CanvasLayer

signal puzzle_correct

@onready var panel: Panel = $Panel
@onready var question_label: Label = $Panel/QuestionLabel
@onready var ans1: LineEdit = $Panel/Ans1
@onready var ans2: LineEdit = $Panel/Ans2

@onready var submit_button: TextureButton = $Panel/SubmitButton
@onready var result_label: Label = $Panel/ResultLabel
@onready var close_button: TextureButton = $Panel/CloseButton

var is_open := false


func _ready():
	add_to_group("analyst_popup")

	panel.visible = false
	result_label.text = ""
	close_button.visible = false

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func open_popup():
	is_open = true
	panel.visible = true

	question_label.visible = true
	ans1.visible = true
	ans2.visible = true
	submit_button.visible = true
	result_label.visible = true
	close_button.visible = false

	result_label.text = ""

	ans1.text = ""
	ans2.text = ""

	await get_tree().process_frame
	ans1.grab_focus()


func close_popup():
	is_open = false
	panel.visible = false

	ans1.release_focus()
	ans2.release_focus()


func _on_submit_pressed():
	var a1 := ans1.text.strip_edges()
	var a2 := ans2.text.strip_edges()

	if a1 == "2" and a2 == "15":
		result_label.text = "Correct"

		var progress = get_tree().get_first_node_in_group("game_progress")
		print("Analyst popup found progress:", progress)

		if progress and progress.has_method("solve_analyst"):
			progress.solve_analyst()

		puzzle_correct.emit()

		await get_tree().create_timer(0.4).timeout
		close_popup()
	else:
		result_label.text = "Try again"
		ans1.grab_focus()


func open_explanation_only():
	is_open = true
	panel.visible = true

	question_label.visible = true
	ans1.visible = false
	ans2.visible = false
	submit_button.visible = false
	result_label.visible = false
	close_button.visible = true

	question_label.text = """Explanation:

135 energy units are available.
Each full battery needs 60 energy units.

135 / 60 = 2 full batteries
135 % 60 = 15 remaining energy

Final answer:
2, 15"""
