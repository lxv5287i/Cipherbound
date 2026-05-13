extends Node

var room5_analyst_solved := false
var room5_coder_solved := false
var room5_drone_solved := false

signal room5_analyst_done
signal room5_coder_done
signal room5_drone_done

func solve_room5_analyst():
	if room5_analyst_solved:
		return

	room5_analyst_solved = true
	room5_analyst_done.emit()


func solve_room5_coder():
	if room5_coder_solved:
		return

	room5_coder_solved = true
	room5_coder_done.emit()


func solve_room5_drone():
	if room5_drone_solved:
		return

	room5_drone_solved = true
	room5_drone_done.emit()


func reset_room5():
	room5_analyst_solved = false
	room5_coder_solved = false
	room5_drone_solved = false
