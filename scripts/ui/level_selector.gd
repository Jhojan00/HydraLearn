extends Control


func _on_editor_pressed() -> void:
	SceneManager.change_scene("uid://bon1xju6xr8s7", {"pattern": "circle", "color": Color.BLACK})


func _on_play_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/level_1.tscn", {"color": Color.BLACK})
