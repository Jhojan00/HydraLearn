extends Control



func _on_quit_pressed() -> void:
	get_tree().quit.call_deferred()
