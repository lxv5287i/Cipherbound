extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $PromptLabel
@onready var popup_panel: Panel = $AnalystPopup/Panel

@onready var clean_container: Control = $AnalystPopup/Panel/Clean
@onready var explanation_label: RichTextLabel = $AnalystPopup/Panel/ExplanationLabel

@onready var parent_option: OptionButton = $AnalystPopup/Panel/Clean/ParentOption
@onready var subclass1_option: OptionButton = $AnalystPopup/Panel/Clean/SubClass1Option
@onready var subclass2_option: OptionButton = $AnalystPopup/Panel/Clean/SubClass2Option

@onready var submit_button: Button = $AnalystPopup/Panel/Submit
@onready var result_label: Label = $AnalystPopup/Panel/Result
@onready var close_button: Button = $AnalystPopup/Panel/Close

var solved := false


func _ready():
	add_to_group("interactable")
	add_to_group("analyst_interactable")

	if normal_texture:
		sprite.texture = normal_texture

	popup_panel.visible = false
	prompt_label.visible = false

	explanation_label.visible = false
	close_button.visible = false

	explanation_label.bbcode_enabled = true
	explanation_label.scroll_active = true
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	if not close_button.pressed.is_connected(close_popup):
		close_button.pressed.connect(close_popup)

	setup_options()


func interact(_player = null):
	if solved:
		open_explanation_only()
	else:
		open_popup()


func show_prompt():
	prompt_label.visible = true

	if inrange_texture:
		sprite.texture = inrange_texture


func hide_prompt():
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

	close_popup()


func open_popup():
	popup_panel.visible = true

	clean_container.visible = true
	submit_button.visible = true
	result_label.visible = true
	explanation_label.visible = false
	close_button.visible = false

	result_label.text = ""


func close_popup():
	popup_panel.visible = false


func setup_options():
	parent_option.clear()
	subclass1_option.clear()
	subclass2_option.clear()

	parent_option.add_item("Select Parent")
	parent_option.add_item("Machine")
	parent_option.add_item("CombatRobot")
	parent_option.add_item("Drone")

	subclass1_option.add_item("Select Subclass 1")
	subclass1_option.add_item("Machine")
	subclass1_option.add_item("CombatRobot")
	subclass1_option.add_item("Drone")

	subclass2_option.add_item("Select Subclass 2")
	subclass2_option.add_item("Machine")
	subclass2_option.add_item("CombatRobot")
	subclass2_option.add_item("Drone")


func get_selected_text(option: OptionButton) -> String:
	return option.get_item_text(option.selected)


func _on_submit_pressed():
	var parent_answer := get_selected_text(parent_option)
	var subclass1_answer := get_selected_text(subclass1_option)
	var subclass2_answer := get_selected_text(subclass2_option)

	if parent_answer == "Machine" \
	and subclass1_answer == "CombatRobot" \
	and subclass2_answer == "Drone":

		solved = true
		GameProgress.solve_room5_analyst()

		result_label.visible = false
		result_label.text = "CHAIN RESTORED"

		show_explanation()
	else:
		result_label.visible = true
		result_label.text = "WRONG HIERARCHY"


func open_explanation_only():
	popup_panel.visible = true
	show_explanation()


func show_explanation():
	clean_container.visible = false
	submit_button.visible = false

	result_label.visible = false
	result_label.text = ""

	explanation_label.visible = true
	close_button.visible = true
