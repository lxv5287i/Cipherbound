extends CanvasLayer

@export var correct_answer := "11 hours, 21 minutes, 7 seconds"

@onready var answer_input: LineEdit = $Panel/AnswerInput
@onready var submit_button: Button = $Panel/SubmitButton
@onready var result_label: Label = $Panel/ResultLabel

var solved := false

func _ready():
	visible = false
	result_label.text = ""
	submit_button.pressed.connect(_on_submit_pressed)
	answer_input.text_submitted.connect(_on_answer_submitted)

func open_popup():
	if solved:
		return

	visible = true
	answer_input.text = ""
	result_label.text = ""
	answer_input.grab_focus()

func close_popup():
	visible = false
	answer_input.release_focus()

func _on_submit_pressed():
	check_answer()

func _on_answer_submitted(_text):
	check_answer()

func check_answer():
	if solved:
		return

	var user_answer := answer_input.text.strip_edges().to_lower()

	if user_answer == "":
		result_label.text = "Please enter an answer."
		return

	var accepted_answers := [
		"11 hours, 21 minutes, 7 seconds",
		"11 hours 21 minutes 7 seconds",
		"11:21:07",
		"11 hrs 21 mins 7 secs"
	]

	for answer in accepted_answers:
		if user_answer == answer:
			solved = true
			result_label.text = "Correct!"

			get_tree().root.get_node("SplitScreenMain/GameProgress").set_analyst_solved()

			await get_tree().create_timer(0.4).timeout
			close_popup()
			return

	result_label.text = "Incorrect. Try again."
