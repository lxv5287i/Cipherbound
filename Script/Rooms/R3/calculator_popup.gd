extends CanvasLayer

signal puzzle_correct

@onready var answer_sfx = $"../AnswerSFX"

@export var exit_door_path: NodePath

@onready var panel: Panel = $Panel

@onready var texture_rect2: NinePatchRect = $Panel/TextureRect2
@onready var texture_rect: NinePatchRect = $Panel/TextureRect

@onready var code_label: RichTextLabel = $Panel/CodeLabel
@onready var explanation_label: RichTextLabel = $Panel/ExplantionLabel

@onready var ans1: LineEdit = $Panel/Ans1
@onready var ans2: LineEdit = $Panel/Ans2
@onready var ans3: LineEdit = $Panel/Ans3
@onready var ans4: LineEdit = $Panel/Ans4
@onready var ans5: LineEdit = $Panel/Ans5
@onready var ans6: LineEdit = $Panel/Ans6

@onready var submit_button: TextureButton = $Panel/SubmitButton
@onready var close_button: TextureButton = $Panel/CloseButton
@onready var result_label: Label = $Panel/Result
@onready var output_display: Label = $Panel/OutputDisplay

var is_open := false
var already_solved := false

var checked_90 := false
var checked_71 := false
var checked_75 := false


func _ready():
	add_to_group("coder_popup")
	hide()

	panel.visible = false
	texture_rect2.visible = false
	texture_rect.visible = false

	explanation_label.visible = false
	result_label.text = ""
	output_display.text = ""
	close_button.visible = false

	explanation_label.bbcode_enabled = true
	explanation_label.scroll_active = true
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func open_popup():
	var progress = get_tree().get_first_node_in_group("game_progress")

	if progress == null:
		print("ERROR: GameProgress not found.")
		return

	if not progress.analyst_solved:
		show()
		panel.visible = true

		texture_rect2.visible = true
		texture_rect.visible = true

		code_label.visible = true
		explanation_label.visible = false
		close_button.visible = true

		code_label.text = "LOCKED\n\nThe Analyst must solve the puzzle first."

		hide_inputs()

		GameLock.movement_locked = true
		is_open = true
		return

	if already_solved:
		open_explanation_only()
		return

	show()
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true

	texture_rect2.visible = true
	texture_rect.visible = true

	code_label.visible = true
	explanation_label.visible = false
	close_button.visible = true

	ans1.visible = true
	ans2.visible = true
	ans3.visible = true
	ans4.visible = true
	ans5.visible = true
	ans6.visible = true

	submit_button.visible = true
	result_label.visible = true

	checked_90 = false
	checked_71 = false
	checked_75 = false

	ans1.text = ""
	ans2.text = ""
	ans3.text = ""
	ans4.text = ""
	ans5.text = ""
	ans6.text = ""

	result_label.text = ""
	output_display.text = ""

	await get_tree().process_frame
	ans1.grab_focus()


func close_popup():
	hide()

	is_open = false
	GameLock.movement_locked = false

	panel.visible = false
	texture_rect2.visible = false
	texture_rect.visible = false

	ans1.release_focus()
	ans2.release_focus()
	ans3.release_focus()
	ans4.release_focus()
	ans5.release_focus()
	ans6.release_focus()


func clean_text(value: String) -> String:
	return value.to_lower().replace(" ", "").strip_edges()


func _on_submit_pressed():
	var a1 := clean_text(ans1.text)
	var a2 := clean_text(ans2.text)
	var a3 := ans3.text.strip_edges()
	var a4 := ans4.text.replace(" ", "").strip_edges()

	var custom_pass_result := ans5.text.strip_edges()
	var custom_fail_result := ans6.text.strip_edges()

	if a1 != "publicclassmain":
		answer_sfx.play_wrong()
		result_label.text = "Line 1 is wrong."
		ans1.grab_focus()
		return

	if (
		a2 != "publicstaticvoidmain(stringargs[])" and
		a2 != "publicstaticvoidmain(string[]args)" and
		a2 != "publicstaticvoidmain(stringargs)"
	):
		answer_sfx.play_wrong()
		result_label.text = "Line 2 is wrong."
		ans2.grab_focus()
		return

	if a3 == "90":
		checked_90 = true
	elif a3 == "71":
		checked_71 = true
	elif a3 == "75":
		checked_75 = true
	else:
		answer_sfx.play_wrong()
		result_label.text = "Line 3 is wrong."
		ans3.grab_focus()
		return

	if a4 != ">=":
		answer_sfx.play_wrong()
		result_label.text = "Line 4 is wrong."
		ans4.grab_focus()
		return

	if checked_90 and checked_71 and checked_75:
		answer_sfx.play_correct()

		output_display.text = "%s\n%s\n%s" % [
			custom_pass_result,
			custom_fail_result,
			custom_pass_result
		]

		if not already_solved:
			already_solved = true
			puzzle_correct.emit()
			open_room_exit_door()

		show_explanation()
		return

	var p1 = "" if checked_90 else "90"
	var p2 = "" if checked_71 else "71"
	var p3 = "" if checked_75 else "75"

	result_label.text = "please check:\n%s\n%s\n%s" % [p1, p2, p3]

	var r1 = custom_pass_result if checked_90 else ""
	var r2 = custom_fail_result if checked_71 else ""
	var r3 = custom_pass_result if checked_75 else ""

	output_display.text = "%s\n%s\n%s" % [r1, r2, r3]

	ans3.text = ""
	ans3.grab_focus()


func open_explanation_only():
	show()

	panel.visible = true
	texture_rect2.visible = true
	texture_rect.visible = true

	GameLock.movement_locked = true
	is_open = true

	show_explanation()


func show_explanation():
	texture_rect2.visible = true
	texture_rect.visible = true

	code_label.visible = false
	explanation_label.visible = true

	hide_inputs()

	submit_button.visible = false
	result_label.visible = false
	close_button.visible = true


func hide_inputs():
	ans1.visible = false
	ans2.visible = false
	ans3.visible = false
	ans4.visible = false
	ans5.visible = false
	ans6.visible = false

	submit_button.visible = false
	result_label.visible = false


func open_room_exit_door():
	var exit_door = get_node_or_null(exit_door_path)

	if exit_door and exit_door.has_method("open_door"):
		exit_door.open_door()
		print("Calculator opened exit door")
	else:
		print("ERROR: ExitDoor not assigned or missing open_door()")
