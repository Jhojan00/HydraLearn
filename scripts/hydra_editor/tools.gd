extends PanelContainer

const CROSS_SMALL = preload("uid://bjdtj755a3air")
const TARGET_ROUND_B = preload("uid://dpwseq4op1qvd")

func _on_delete_pressed() -> void:
	Input.set_custom_mouse_cursor(CROSS_SMALL)


func _on_cable_pressed() -> void:
	Input.set_custom_mouse_cursor(TARGET_ROUND_B)
