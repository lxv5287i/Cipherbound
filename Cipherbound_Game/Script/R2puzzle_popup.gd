extends CanvasLayer

signal puzzle_solved

@onready var input_h: LineEdit = $Panel/InputH
@onready var input_m1: LineEdit = $Panel/InputM1
@onready var input_m2: LineEdit = $Panel/InputM2
@onready var input_s: LineEdit = $Panel/InputS
@onready var submit_button: Button = $Panel/SubmitButton
@onready var result_label: Label = $Panel/ResultLabel

var solved := false

func _ready():
	visible = false
	result_label.text = ""
	submit_button.pressed.connect(_on_submit_pressed)

func open_popup():
	if solved:
		return

	visible = true
	result_label.text = ""

	input_h.text = ""
	input_m1.text = ""
	input_m2.text = ""
	input_s.text = ""

	input_h.grab_focus()

func close_popup():
	visible = false
	input_h.release_focus()
	input_m1.release_focus()
	input_m2.release_focus()
	input_s.release_focus()

func _on_submit_pressed():
	if solved:
		return

	var h := input_h.text.strip_edges()
	var m1 := input_m1.text.strip_edges()
	var m2 := input_m2.text.strip_edges()
	var s := input_s.text.strip_edges()

	if h == "" or m1 == "" or m2 == "" or s == "":
		result_label.text = "Fill all blanks."
		return

	if h == "40867" and m1 == "3600" and m2 == "60" and s == "60":
		solved = true
		result_label.text = "Correct! Power ON."

		get_tree().root.get_node("SplitScreenMain/GameProgress").set_coder_solved()
		emit_signal("puzzle_solved")

		await get_tree().create_timer(0.4).timeout
		close_popup()
	else:
		result_label.text = "Incorrect. Try again."
