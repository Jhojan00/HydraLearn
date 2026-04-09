extends Control


func _on_editor_pressed() -> void:
	SceneManager.change_scene("uid://baacxcvuseilj", {"pattern": "circle", "color": Color.BLACK})
