extends Node2D

var robot_done := false
var analyst_done := false
var coder_done := false


func _ready():
	add_to_group("tutorial_level")


func unlock_analyst():
	robot_done = true


func solve_analyst():
	analyst_done = true


func solve_coder():
	coder_done = true
