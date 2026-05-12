extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label

@onready var popup_panel: Panel = $CoderPopup/Panel

@onready var code_label: RichTextLabel = $CoderPopup/Panel/CodeLabel
@onready var explanation_label: RichTextLabel = $CoderPopup/Panel/RichTextLabel

@onready var grid_container: GridContainer = $CoderPopup/Panel/GridContainer

@onready var ans1: LineEdit = $CoderPopup/Panel/GridContainer/Ans1
@onready var ans2: LineEdit = $CoderPopup/Panel/GridContainer/Ans2
@onready var ans3: LineEdit = $CoderPopup/Panel/GridContainer/Ans3
@onready var ans4: LineEdit = $CoderPopup/Panel/GridContainer/Ans4
@onready var ans5: LineEdit = $CoderPopup/Panel/GridContainer/Ans5
@onready var ans6: LineEdit = $CoderPopup/Panel/GridContainer/Ans6
@onready var ans7: LineEdit = $CoderPopup/Panel/GridContainer/Ans7
@onready var ans8: LineEdit = $CoderPopup/Panel/GridContainer/Ans8
@onready var ans9: LineEdit = $CoderPopup/Panel/GridContainer/Ans9
@onready var ans10: LineEdit = $CoderPopup/Panel/GridContainer/Ans10
@onready var ans11: LineEdit = $CoderPopup/Panel/GridContainer/Ans11
@onready var ans12: LineEdit = $CoderPopup/Panel/GridContainer/Ans12

@onready var submit_button: TextureButton = $CoderPopup/Panel/SubmitButton
@onready var result_label: Label = $CoderPopup/Panel/ResultLabel
@onready var close_button: TextureButton = $CoderPopup/Panel/CloseButton

var solved := false


func _ready():
	add_to_group("coder_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	popup_panel.visible = false
	prompt_label.visible = false

	close_button.visible = false
	explanation_label.visible = false

	code_label.bbcode_enabled = true
	code_label.scroll_active = true
	code_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	explanation_label.bbcode_enabled = true
	explanation_label.scroll_active = true
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)

	if not GameProgress.room5_analyst_done.is_connected(_on_analyst_done):
		GameProgress.room5_analyst_done.connect(_on_analyst_done)

	setup_placeholders()
	update_prompt_text()


func interact():
	if not GameProgress.room5_analyst_solved:
		prompt_label.text = "[LOCKED]"
		return

	if solved:
		open_explanation_only()
	else:
		open_popup()


func show_prompt():
	prompt_label.visible = true
	update_prompt_text()

	if inrange_texture:
		sprite.texture = inrange_texture


func hide_prompt():
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	close_popup()


func update_prompt_text():
	if GameProgress.room5_analyst_solved:
		prompt_label.text = "PRESS [E]"
	else:
		prompt_label.text = "[LOCKED]"


func _on_analyst_done():
	update_prompt_text()


func open_popup():
	popup_panel.visible = true
	GameLock.movement_locked = true

	code_label.visible = true
	explanation_label.visible = false

	grid_container.visible = true
	submit_button.visible = true
	result_label.visible = true
	close_button.visible = false

	result_label.text = ""

	clear_answers()


func close_popup():
	popup_panel.visible = false
	GameLock.movement_locked = false


func setup_placeholders():
	ans1.placeholder_text = "1"
	ans2.placeholder_text = "2"
	ans3.placeholder_text = "3"
	ans4.placeholder_text = "4"
	ans5.placeholder_text = "5"
	ans6.placeholder_text = "6"
	ans7.placeholder_text = "7"
	ans8.placeholder_text = "8"
	ans9.placeholder_text = "9"
	ans10.placeholder_text = "10"
	ans11.placeholder_text = "11"
	ans12.placeholder_text = "12"


func clear_answers():
	ans1.text = ""
	ans2.text = ""
	ans3.text = ""
	ans4.text = ""
	ans5.text = ""
	ans6.text = ""
	ans7.text = ""
	ans8.text = ""
	ans9.text = ""
	ans10.text = ""
	ans11.text = ""
	ans12.text = ""


func clean_text(value: String) -> String:
	return value.strip_edges()


func _on_submit_pressed():
	if clean_text(ans1.text) == "" \
	and clean_text(ans2.text) == "" \
	and clean_text(ans3.text) == "" \
	and clean_text(ans4.text) == "" \
	and clean_text(ans5.text) == "" \
	and clean_text(ans6.text) == "" \
	and clean_text(ans7.text) == "" \
	and clean_text(ans8.text) == "" \
	and clean_text(ans9.text) == "" \
	and clean_text(ans10.text) == "" \
	and clean_text(ans11.text) == "" \
	and clean_text(ans12.text) == "":
		result_label.visible = true
		result_label.text = "Please input answer"
		ans1.grab_focus()
		return

	var correct := true
	var error_text := ""

	if clean_text(ans1.text) != "this":
		correct = false
		error_text = "Answer 1 is wrong."
	elif clean_text(ans2.text) != "powerOn()":
		correct = false
		error_text = "Answer 2 is wrong."
	elif clean_text(ans3.text) != "extends":
		correct = false
		error_text = "Answer 3 is wrong."
	elif clean_text(ans4.text) != "super":
		correct = false
		error_text = "Answer 4 is wrong."
	elif clean_text(ans5.text) != "void attack()":
		correct = false
		error_text = "Answer 5 is wrong."
	elif clean_text(ans6.text) != "extends":
		correct = false
		error_text = "Answer 6 is wrong."
	elif clean_text(ans7.text) != "String name":
		correct = false
		error_text = "Answer 7 is wrong."
	elif clean_text(ans8.text) != "System.out.println":
		correct = false
		error_text = "Answer 8 is wrong."
	elif clean_text(ans9.text) != "public class Main":
		correct = false
		error_text = "Answer 9 is wrong."
	elif clean_text(ans10.text) != "public static void main":
		correct = false
		error_text = "Answer 10 is wrong."
	elif clean_text(ans11.text) != "Drone":
		correct = false
		error_text = "Answer 11 is wrong."
	elif clean_text(ans12.text) != "fly":
		correct = false
		error_text = "Answer 12 is wrong."

	if correct:
		solved = true
		GameProgress.solve_room5_coder()
		show_explanation_only()
	else:
		result_label.visible = true
		result_label.text = error_text


func open_explanation_only():
	popup_panel.visible = true
	GameLock.movement_locked = true
	show_explanation_only()


func show_explanation_only():
	code_label.visible = false
	explanation_label.visible = true

	grid_container.visible = false
	submit_button.visible = false
	result_label.visible = false

	close_button.visible = true
