extends CanvasLayer

signal puzzle_correct

@onready var answer_sfx = $"../AnswerSFX"

@export_multiline var question_text: String = ""
@export_multiline var result_text: String = ""

@onready var panel: Panel = $Panel
@onready var code_label: Label = $Panel/CodeLabel

@onready var explanation_label: RichTextLabel = $Panel/ExplanationLabel

@onready var ans1: LineEdit = $Panel/Ans1
@onready var ans2: LineEdit = $Panel/Ans2
@onready var ans3: LineEdit = $Panel/Ans3
@onready var ans4: LineEdit = $Panel/Ans4
@onready var ans5: LineEdit = $Panel/Ans5
@onready var ans6: LineEdit = $Panel/Ans6

@onready var submit_button: TextureButton = $Panel/Submit
@onready var result_label: Label = $Panel/Result
@onready var close_button: TextureButton = $Panel/Close

var is_open := false
var already_solved := false


func _ready():
	add_to_group("coder_popup")

	panel.visible = false
	result_label.text = ""

	close_button.visible = false
	explanation_label.visible = false

	explanation_label.bbcode_enabled = true
	explanation_label.scroll_active = true
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	submit_button.pressed.connect(_on_submit_pressed)
	close_button.pressed.connect(close_popup)


func open_popup():
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true

	if already_solved:
		show_explanation_only()
	else:
		show_question()


func show_question():
	code_label.visible = true
	explanation_label.visible = false

	ans1.visible = true
	ans2.visible = true
	ans3.visible = true
	ans4.visible = true
	ans5.visible = true
	ans6.visible = true

	submit_button.visible = true
	result_label.visible = true
	close_button.visible = true

	code_label.text = question_text

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


func clean_text(value: String) -> String:
	return value.to_lower().replace(" ", "").strip_edges()


func _on_submit_pressed():
	if ans1.text.strip_edges() != "for":
		answer_sfx.play_wrong()
		result_label.text = "INCORRECT"
		ans1.grab_focus()
		return

	if ans2.text.strip_edges() != "1":
		answer_sfx.play_wrong()
		result_label.text = "INCORRECT"
		ans2.grab_focus()
		return

	if ans3.text.strip_edges() != "3":
		answer_sfx.play_wrong()
		result_label.text = "INCORRECT"
		ans3.grab_focus()
		return

	if ans4.text.strip_edges() != "i++":
		answer_sfx.play_wrong()
		result_label.text = "INCORRECT"
		ans4.grab_focus()
		return

	var line5 := clean_text(ans5.text)
	var line6 := clean_text(ans6.text)

	if line5 != "system.out.print(\"*\")":
		answer_sfx.play_wrong()
		result_label.text = "INCORRECT"
		ans5.grab_focus()
		return

	if (
		line6 != "system.out.println()" and
		line6 != "system.out.print(\"\\n\")"
	):
		answer_sfx.play_wrong()
		result_label.text = "INCORRECT"
		ans6.grab_focus()
		return

	answer_sfx.play_correct()

	result_label.visible = true
	result_label.text = "*
	**
	***"

	if not already_solved:
		already_solved = true
		puzzle_correct.emit()

	await get_tree().create_timer(1.5).timeout

	show_explanation_only()


func show_explanation_only():
	code_label.visible = false
	explanation_label.visible = true

	ans1.visible = false
	ans2.visible = false
	ans3.visible = false
	ans4.visible = false
	ans5.visible = false
	ans6.visible = false

	submit_button.visible = false
	result_label.visible = false

	close_button.visible = true


func open_explanation_only():
	is_open = true
	GameLock.movement_locked = true
	panel.visible = true

	show_explanation_only()
