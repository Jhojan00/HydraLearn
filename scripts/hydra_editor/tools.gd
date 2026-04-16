extends PanelContainer


const CROSS_SMALL = preload("uid://bjdtj755a3air")
const TARGET_ROUND_B = preload("uid://btke2pvbe146s")


func _on_delete_pressed() -> void:
	Input.set_custom_mouse_cursor(CROSS_SMALL, Input.CURSOR_ARROW, Vector2(10, 10))

func _on_cable_pressed() -> void:
	Input.set_custom_mouse_cursor(TARGET_ROUND_B, Input.CURSOR_ARROW, Vector2(10, 10))
