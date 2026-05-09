extends CanvasLayer

@export_multiline var question_text: String = "What structure is used when the program chooses between two possible actions?"
@export_multiline var explanation_text: String = "Explanation:\n\nIf else is used when the program needs to choose between two possible actions."

@onready var panel: Panel = $Panel
@onready var question_label: Label = $Panel/QuestionLabel
@onready var answer_input: LineEdit = $Panel/Ans
@onready var submit_button: Button = $Panel/SubmitButton
@onready var close_button: Button = $Panel/CloseButton
@onready var result_label: Label = $Panel/Result

var is_open := false
var solved := false


func _ready():
	panel.visible = false
	close_button.visible = false
	result_label.text = ""

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func open_popup():
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true
	question_label.text = question_text

	if solved:
		show_explanation()
		return

	answer_input.visible = true
	submit_button.visible = true
	close_button.visible = false
	result_label.visible = true

	answer_input.text = ""
	result_label.text = ""

	await get_tree().process_frame
	answer_input.grab_focus()


func close_popup():
	is_open = false
	GameLock.movement_locked = false

	panel.visible = false
	answer_input.release_focus()


func _on_submit_pressed():
	var user_answer := answer_input.text.strip_edges().to_lower()

	if user_answer == "if else" or user_answer == "ifelse":
		result_label.text = "Correct"
		solved = true

		submit_button.visible = false
		answer_input.visible = false
		result_label.visible = false

		var progress = get_tree().get_first_node_in_group("game_progress")
		print("Room 3 analyst answer found progress:", progress)

		if progress and progress.has_method("solve_analyst"):
			progress.solve_analyst()

		show_explanation()
	else:
		result_label.text = "Try again"
		answer_input.grab_focus()


func show_explanation():
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true

	answer_input.visible = false
	submit_button.visible = false
	result_label.visible = false
	close_button.visible = true

	question_label.text = explanation_text
