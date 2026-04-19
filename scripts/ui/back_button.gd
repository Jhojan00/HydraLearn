extends "res://scripts/ui/hidra_icon_button.gd"

@export var next_scene: String
@export var setted_options: Dictionary

func _on_pressed() -> void:
	super._on_pressed()
	
	if not setted_options:
		SceneManager.change_scene(next_scene)
	else:
		SceneManager.change_scene(next_scene, setted_options)
