extends Control


func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(640, 360))

func _on_quit_pressed() -> void:
	get_tree().quit.call_deferred()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("uid://cjp5pyapkg5py")
