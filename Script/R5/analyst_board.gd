extends Area2D

@export var normal_texture: Texture2D
@export var inrange_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt_label: Label = $PromptLabel
@onready var popup_panel: Panel = $AnalystPopup/Panel

@onready var parent_option: OptionButton = $AnalystPopup/Panel/Clean/ParentOption
@onready var subclass1_option: OptionButton = $AnalystPopup/Panel/Clean/SubClass1Option
@onready var subclass2_option: OptionButton = $AnalystPopup/Panel/Clean/SubClass2Option

@onready var submit_button: Button = $AnalystPopup/Panel/Submit
@onready var result_label: Label = $AnalystPopup/Panel/Result

func _ready():
	add_to_group("interactable")

	if normal_texture:
		sprite.texture = normal_texture

	popup_panel.visible = false
	prompt_label.visible = false

	submit_button.pressed.connect(_on_submit_pressed)

	setup_options()

func interact():
	open_popup()

func show_prompt():
	prompt_label.visible = true

	if inrange_texture:
		sprite.texture = inrange_texture

func hide_prompt():
	prompt_label.visible = false

	if normal_texture:
		sprite.texture = normal_texture

func open_popup():
	popup_panel.visible = true
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

		result_label.text = "CHAIN RESTORED"
		GameProgress.solve_room5_analyst()
		close_popup()

	else:
		result_label.text = "WRONG HIERARCHY"
