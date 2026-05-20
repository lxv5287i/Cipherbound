extends CanvasLayer

signal puzzle_correct

@onready var answer_sfx = $"../AnswerSFX"

@onready var panel: Panel = $Panel
@onready var question_label: Label = $Panel/QuestionLabel

@onready var ans1: LineEdit = $Panel/Ans1
@onready var ans2: LineEdit = $Panel/Ans2
@onready var ans3: LineEdit = $Panel/Ans3

@onready var result_label: Label = $Panel/ResultLabel

@onready var done_button: TextureButton = $Panel/DoneButton
@onready var submit_button: TextureButton = $Panel/SubmitButton
@onready var close_button: TextureButton = $Panel/CloseButton

var is_open := false
var puzzle_done := false
var correct_answers := ["135", "60", "%"]
var x := 0
var i := 5

func _ready():
	add_to_group("coder_popup")

	hide()
	panel.visible = false

	result_label.visible = false
	done_button.visible = false

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)

	if not done_button.pressed.is_connected(close_popup):
		done_button.pressed.connect(close_popup)


func open_popup():
	show()
	is_open = true
	panel.visible = true

	ans1.visible = true
	ans2.visible = true
	ans3.visible = true

	close_button.visible = true

	if puzzle_done:
		submit_button.visible = false
		done_button.visible = true

		result_label.visible = true
		result_label.text = "CORRECT"

	else:
		submit_button.visible = true
		done_button.visible = false

		result_label.visible = false
		result_label.text = ""

		ans1.text = ""
		ans2.text = ""
		ans3.text = ""

		await get_tree().process_frame
		ans1.grab_focus()


func close_popup():
	hide()
	is_open = false
	panel.visible = false

	ans1.release_focus()
	ans2.release_focus()
	ans3.release_focus()


func _on_submit_pressed():
	var a1 := ans1.text.strip_edges()
	var a2 := ans2.text.strip_edges()
	var a3 := ans3.text.strip_edges()

	result_label.visible = true

	if a1 == correct_answers[0] and a2 == correct_answers[1] and a3 == correct_answers[2]:
		answer_sfx.play_correct()

		puzzle_done = true

		result_label.text = "Remaining Energy: 15\nBatteries: 2"

		puzzle_correct.emit()

		submit_button.visible = false
		done_button.visible = true
		close_button.visible = true

	else:
		answer_sfx.play_wrong()
		
		GameTimer.add_penalty(i)
		if i < 30:
			x+=1
			if x == 5:
				i += 5
				x = 0
			
		result_label.text = "INCORRECT!\n-" + str(i) + " SECONDS"

		submit_button.visible = true
		done_button.visible = false
		close_button.visible = true

		ans1.grab_focus()
