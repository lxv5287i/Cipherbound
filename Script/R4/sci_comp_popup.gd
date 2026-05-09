extends CanvasLayer

signal puzzle_correct

@export_multiline var explanation_text: String = "Explanation"

@onready var panel: Panel = $Panel
@onready var code_label: Label = $Panel/CodeLabel

@onready var ans1: LineEdit = $Panel/Ans1
@onready var ans2: LineEdit = $Panel/Ans2
@onready var ans3: LineEdit = $Panel/Ans3
@onready var ans4: LineEdit = $Panel/Ans4
@onready var ans5: LineEdit = $Panel/Ans5
@onready var ans6: LineEdit = $Panel/Ans6

@onready var submit_button: Button = $Panel/Submit
@onready var result_label: Label = $Panel/Result
@onready var next_button: Button = $Panel/Next

var is_open := false
var already_solved := false


func _ready():
	add_to_group("coder_popup")

	panel.visible = false
	next_button.visible = false
	result_label.text = ""

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.connect(_on_next_pressed)


func open_popup():
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true
	code_label.visible = true

	if already_solved:
		show_explanation()
		return

	ans1.visible = true
	ans2.visible = true
	ans3.visible = true
	ans4.visible = true
	ans5.visible = true
	ans6.visible = true

	submit_button.visible = true
	result_label.visible = true
	next_button.visible = false

	ans1.text = ""
	ans2.text = ""
	ans3.text = ""
	ans4.text = ""
	ans5.text = ""
	ans6.text = ""

	result_label.text = ""

	await get_tree().process_frame
	ans1.grab_focus()


func close_popup():
	is_open = false
	GameLock.movement_locked = false

	panel.visible = false

	ans1.release_focus()
	ans2.release_focus()
	ans3.release_focus()
	ans4.release_focus()
	ans5.release_focus()
	ans6.release_focus()


func _on_submit_pressed():
	var a1 := ans1.text.strip_edges()
	var a2 := ans2.text.strip_edges()
	var a3 := ans3.text.strip_edges()
	var a4 := ans4.text.strip_edges()
	var a5 := ans5.text.strip_edges()
	var a6 := ans6.text.strip_edges()

	if a1 != "for":
		result_label.text = "Line 1 is wrong."
		ans1.grab_focus()
		return

	if a2 != "1":
		result_label.text = "Line 2 is wrong."
		ans2.grab_focus()
		return

	if a3 != "3":
		result_label.text = "Line 3 is wrong."
		ans3.grab_focus()
		return

	if a4 != "i++":
		result_label.text = "Line 4 is wrong."
		ans4.grab_focus()
		return

	if a5 != "System.out.print(\"*\")":
		result_label.text = "Line 5 is wrong."
		ans5.grab_focus()
		return

	if a6 != "System.out.println()":
		result_label.text = "Line 6 is wrong."
		ans6.grab_focus()
		return

	result_label.text = "Correct"

	if not already_solved:
		already_solved = true
		puzzle_correct.emit()

	show_explanation()


func _on_next_pressed():
	close_popup()


func open_explanation_only():
	is_open = true
	GameLock.movement_locked = true
	panel.visible = true
	show_explanation()


func show_explanation():
	ans1.visible = false
	ans2.visible = false
	ans3.visible = false
	ans4.visible = false
	ans5.visible = false
	ans6.visible = false

	submit_button.visible = false
	result_label.visible = false
	next_button.visible = true

	code_label.text = explanation_text
