extends Area2D

signal puzzle_correct

@export var locked_texture: Texture2D
@export var locked_inrange_texture: Texture2D
@export var unlocked_texture: Texture2D
@export var unlocked_inrange_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $Label
@onready var blocker: Node2D = $Blocker
@onready var blocker_collision: CollisionShape2D = $Blocker/CollisionShape2D

@onready var panel: Panel = $CanvasLayer/Panel
@onready var problem_label: RichTextLabel = $CanvasLayer/Panel/Problem
@onready var explanation_label: RichTextLabel = $CanvasLayer/Panel/Explanation

@onready var ans1: LineEdit = $CanvasLayer/Panel/ans1
@onready var ans2: LineEdit = $CanvasLayer/Panel/ans2
@onready var ans3: LineEdit = $CanvasLayer/Panel/ans3
@onready var ans4: LineEdit = $CanvasLayer/Panel/ans4

@onready var result_label: Label = $CanvasLayer/Panel/Result
@onready var output_label: Label = $CanvasLayer/Panel/Output

@onready var submit_button: TextureButton = $CanvasLayer/Panel/Submit
@onready var close_button: TextureButton = $CanvasLayer/Panel/Close

@onready var answer_sfx = $"../AnswerSFX"

@export_multiline var problem_text: String = ""
@export_multiline var explanation_text: String = ""

var unlocked := false
var solved := false
var analyst_in_range := false


func _ready():
	add_to_group("drone_robot")

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	panel.visible = false
	prompt_label.visible = false

	result_label.visible = false
	output_label.visible = false
	explanation_label.visible = false

	problem_label.bbcode_enabled = true
	problem_label.text = problem_text

	explanation_label.bbcode_enabled = true
	explanation_label.text = explanation_text

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)

	if not GameProgress.room5_coder_done.is_connected(unlock_drone):
		GameProgress.room5_coder_done.connect(unlock_drone)

	if GameProgress.room5_coder_solved:
		unlock_drone()
	else:
		lock_drone()


func _process(_delta):
	if GameLock.movement_locked:
		return

	if analyst_in_range and Input.is_action_just_pressed("a_interact"):
		interact()


func lock_drone():
	unlocked = false
	update_state()

	if blocker:
		blocker.visible = true

	if blocker_collision:
		blocker_collision.disabled = false


func unlock_drone():
	unlocked = true
	print("Drone robot unlocked")
	update_state()

	if blocker:
		blocker.visible = false

	if blocker_collision:
		blocker_collision.disabled = true


func _on_body_entered(body):
	if body.name != "AnalystPlayer":
		return

	analyst_in_range = true
	update_state()


func _on_body_exited(body):
	if body.name != "AnalystPlayer":
		return

	analyst_in_range = false
	update_state()


func update_state():
	if not analyst_in_range:
		prompt_label.visible = false

		if unlocked:
			if unlocked_texture:
				sprite.texture = unlocked_texture
		else:
			if locked_texture:
				sprite.texture = locked_texture

		return

	prompt_label.visible = true

	if unlocked:
		prompt_label.text = "[SPACE]"

		if unlocked_inrange_texture:
			sprite.texture = unlocked_inrange_texture
		elif unlocked_texture:
			sprite.texture = unlocked_texture
	else:
		prompt_label.text = "[LOCKED]"

		if locked_inrange_texture:
			sprite.texture = locked_inrange_texture
		elif locked_texture:
			sprite.texture = locked_texture


func interact():
	if not unlocked:
		prompt_label.text = "[LOCKED]"
		return

	if solved:
		open_explanation_only()
	else:
		open_popup()


func open_popup():
	panel.visible = true
	GameLock.movement_locked = true

	problem_label.visible = true
	explanation_label.visible = false

	ans1.visible = true
	ans2.visible = true
	ans3.visible = true
	ans4.visible = true

	submit_button.visible = true
	close_button.visible = true

	result_label.visible = false
	output_label.visible = false

	result_label.text = ""
	output_label.text = ""

	ans1.text = ""
	ans2.text = ""
	ans3.text = ""
	ans4.text = ""

	await get_tree().process_frame
	ans1.grab_focus()


func close_popup():
	panel.visible = false
	GameLock.movement_locked = false

	ans1.release_focus()
	ans2.release_focus()
	ans3.release_focus()
	ans4.release_focus()


func clean_text(value: String) -> String:
	return value.to_lower().replace(" ", "").strip_edges()


func _on_submit_pressed():
	var a1 := clean_text(ans1.text)
	var a2 := clean_text(ans2.text)
	var a3 := clean_text(ans3.text)
	var a4 := clean_text(ans4.text)

	result_label.visible = true

	if a1 == "" or a2 == "" or a3 == "" or a4 == "":
		answer_sfx.play_wrong()
		result_label.text = "Complete your answer."
		return

	if a1 != "publicclassmain":
		answer_sfx.play_wrong()
		result_label.text = "Line 9 is incorrect."
		ans1.grab_focus()
		return

	if a2 != "publicstaticvoidmain":
		answer_sfx.play_wrong()
		result_label.text = "Line 10 is incorrect."
		ans2.grab_focus()
		return

	if a3 != "drone":
		answer_sfx.play_wrong()
		result_label.text = "Line 11 is incorrect."
		ans3.grab_focus()
		return

	if a4 != "fly();":
		answer_sfx.play_wrong()
		result_label.text = "Line 12 is incorrect."
		ans4.grab_focus()
		return

	answer_sfx.play_correct()

	solved = true

	result_label.visible = true
	result_label.text = "CORRECT"

	output_label.visible = true
	output_label.text = "UNIT-7: SYSTEM ONLINE\nUNIT-7: FIRING WEAPONS\nUNIT-7: TAKING FLIGHT"

	problem_label.visible = false
	explanation_label.visible = true

	ans1.visible = false
	ans2.visible = false
	ans3.visible = false
	ans4.visible = false

	submit_button.visible = false
	close_button.visible = true

	GameProgress.solve_room5_drone()
	puzzle_correct.emit()


func open_explanation_only():
	panel.visible = true
	GameLock.movement_locked = true

	problem_label.visible = false
	explanation_label.visible = true

	ans1.visible = false
	ans2.visible = false
	ans3.visible = false
	ans4.visible = false

	submit_button.visible = false

	result_label.visible = true
	result_label.text = "CORRECT"

	output_label.visible = true
	output_label.text = "UNIT-7: SYSTEM ONLINE\nUNIT-7: FIRING WEAPONS\nUNIT-7: TAKING FLIGHT"

	close_button.visible = true
