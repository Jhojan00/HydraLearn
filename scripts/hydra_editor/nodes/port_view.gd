extends TextureRect


func _on_mouse_entered() -> void:
	modulate = Color.LIGHT_BLUE

func _on_mouse_exited() -> void:
	modulate = Color.WHITE
