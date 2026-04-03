extends Control


func _on_back_pressed() -> void:
	SceneManager.change_scene("uid://dchlm4wvis2f3")


func _on_editor_pressed() -> void:
	SceneManager.change_scene("uid://baacxcvuseilj", {"pattern": "circle", "color": Color.BLACK})
