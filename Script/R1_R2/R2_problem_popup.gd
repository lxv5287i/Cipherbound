extends CanvasLayer

signal puzzle_correct

@onready var panel: Panel = $Panel
@onready var question_label: Label = $Panel/QuestionLabel

@onready var ans1: LineEdit = $Panel/Ans1
@onready var ans2: LineEdit = $Panel/Ans2
@onready var ans3: LineEdit = $Panel/Ans3

@onready var submit_button: TextureButton = $Panel/SubmitButton
@onready var result_label: Label = $Panel/ResultLabel

@onready var next_button: TextureButton = $Panel/NextButton
@onready var close_button: TextureButton = $Panel/CloseButton

var is_open := false
var correct_answers := ["135", "60", "%"]


func _ready():
	add_to_group("coder_popup")

	panel.visible = false
	next_button.visible = false
	close_button.visible = false
	result_label.text = ""

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.connect(_on_next_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func open_popup():
	is_open = true
	panel.visible = true

	ans1.visible = true
	ans2.visible = true
	ans3.visible = true

	submit_button.visible = true
	result_label.visible = true

	next_button.visible = false
	close_button.visible = false

	result_label.text = ""

	ans1.text = ""
	ans2.text = ""
	ans3.text = ""

	await get_tree().process_frame
	ans1.grab_focus()


func close_popup():
	is_open = false
	panel.visible = false

	ans1.release_focus()
	ans2.release_focus()
	ans3.release_focus()


func _on_submit_pressed():
	var a1 := ans1.text.strip_edges()
	var a2 := ans2.text.strip_edges()
	var a3 := ans3.text.strip_edges()

	if a1 == correct_answers[0] and a2 == correct_answers[1] and a3 == correct_answers[2]:
		result_label.text = "Correct"

		puzzle_correct.emit()

		next_button.visible = true
		submit_button.visible = false
	else:
		result_label.text = "Try again"
		ans1.grab_focus()


func _on_next_pressed():
	ans1.visible = false
	ans2.visible = false
	ans3.visible = false

	submit_button.visible = false
	result_label.visible = false
	next_button.visible = false

	close_button.visible = true

	question_label.text = """energy = 135

Each battery stores 60 energy units.

135 / 60 = 2 full batteries
135 % 60 = 15 remaining energy

Completed logic:

SET energy = 135
batteries = energy / 60
remainingEnergy = energy % 60"""


func open_explanation_only():
	is_open = true
	panel.visible = true

	ans1.visible = false
	ans2.visible = false
	ans3.visible = false

	submit_button.visible = false
	result_label.visible = false

	next_button.visible = false
	close_button.visible = true

	question_label.text = """energy = 135

Each battery stores 60 energy 
units.

135 / 60 = 2 full batteries
135 % 60 = 15 remaining 
energy

Completed logic:

SET energy = 135
batteries = energy / 60
remainingEnergy = energy % 60"""
