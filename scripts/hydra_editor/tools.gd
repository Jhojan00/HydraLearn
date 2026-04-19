extends PanelContainer

func _on_delete_pressed() -> void:
	State.change_mode(State.MODES.DELETE)


func _on_normal_pressed() -> void:
	State.change_mode(State.MODES.NORMAL)
