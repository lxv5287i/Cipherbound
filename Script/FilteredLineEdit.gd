extends LineEdit

enum FilterMode {
	NONE,
	BLOCK_WASDE,
	BLOCK_ARROWS
}

@export var filter_mode: FilterMode = FilterMode.NONE

func _gui_input(event):
	if not has_focus():
		return

	if event is InputEventKey and event.pressed:
		var key: int = event.keycode

		# BLOCK WASD completely
		if filter_mode == FilterMode.BLOCK_WASDE:
			if key in [KEY_W, KEY_A, KEY_S, KEY_D,KEY_E]:
				accept_event()
				release_focus()   # <- CRITICAL
				grab_focus()
				return

		# BLOCK ARROWS completely
		if filter_mode == FilterMode.BLOCK_ARROWS:
			if key in [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]:
				accept_event()
				return
