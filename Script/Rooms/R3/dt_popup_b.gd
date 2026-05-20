extends CanvasLayer

@onready var answer_sfx = $"../AnswerSFX"

@onready var panel: Panel = $Panel

@onready var question_label: Label = $Panel/QuestionLabel
@onready var explanation_label: RichTextLabel = $Panel/ExplanationLabel

@onready var answer_input: LineEdit = $Panel/Ans

@onready var submit_button: TextureButton = $Panel/SubmitButton
@onready var close_button: TextureButton = $Panel/CloseButton

@onready var result_label: Label = $Panel/Result

var is_open := false
var solved := false

var x := 0
var i := 5

func _ready():
	panel.visible = false

	explanation_label.visible = false
	close_button.visible = true
	result_label.visible = false
	result_label.text = ""

	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	explanation_label.bbcode_enabled = true
	explanation_label.scroll_active = true
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)


func open_popup():
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true
	close_button.visible = true

	if solved:
		show_explanation()
		return

	question_label.visible = true
	explanation_label.visible = false

	answer_input.visible = true
	submit_button.visible = true
	result_label.visible = false

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
	var user_answer := answer_input.text.to_lower().replace(" ", "").strip_edges()

	result_label.visible = true

	if user_answer == "":
		answer_sfx.play_wrong()
		result_label.text = "Please input answer"
		answer_input.grab_focus()
		return

	if user_answer == "ifelse":
		answer_sfx.play_correct()

		result_label.text = "CORRECT"
		solved = true

		var progress = get_tree().get_first_node_in_group("game_progress")
		print("Room 3 analyst answer found progress:", progress)

		if progress and progress.has_method("solve_analyst"):
			progress.solve_analyst()

		submit_button.visible = false
		answer_input.visible = false
		close_button.visible = true

		return

	answer_sfx.play_wrong()
	GameTimer.add_penalty(i)
	if i < 30:
		x+=1
		if x == 5:
				i += 5
				x = 0
			
		result_label.text = "INCORRECT!\n-" + str(i) + " SECONDS"
	answer_input.grab_focus()


func show_explanation():
	is_open = true
	GameLock.movement_locked = true

	panel.visible = true

	question_label.visible = false
	explanation_label.visible = true

	answer_input.visible = false
	submit_button.visible = false
	result_label.visible = false
	close_button.visible = true
