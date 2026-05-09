extends Node2D

@export var broken_texture: Texture2D
@export var online_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var status_label: Label = $Label

func _ready():
	sprite.texture = broken_texture
	status_label.text = "BROKEN"

	GameProgress.room5_coder_done.connect(_on_coder_done)

func _on_coder_done():
	sprite.texture = online_texture

	status_label.text = "UNIT-7: SYSTEM ONLINE"
	await get_tree().create_timer(0.7).timeout

	status_label.text = "UNIT-7: FIRING WEAPONS"
	await get_tree().create_timer(0.7).timeout

	status_label.text = "UNIT-7: TAKING FLIGHT"
