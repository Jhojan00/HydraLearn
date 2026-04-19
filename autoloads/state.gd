extends Node

enum MODES {
	NORMAL,
	DELETE
}

var modes_map = {
	MODES.NORMAL: [preload("uid://b336yuetqyo50"), Vector2.ZERO],
	MODES.DELETE: [preload("uid://bjdtj755a3air"), Vector2(20, 20)]
	
}

var _current_mode = MODES.NORMAL


func change_mode(mode: MODES):
	if modes_map.has(mode):
		Input.set_custom_mouse_cursor(modes_map[mode][0], Input.CURSOR_ARROW, modes_map[mode][1])
		_current_mode = mode
	else:
		push_warning("No cursor mode [%s] found." % str(mode))
	
func get_mode():
	return _current_mode
