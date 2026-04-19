extends Control


func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(640, 360))
	
	TranslationServer.set_locale("es")

func _on_quit_pressed() -> void:
	get_tree().quit.call_deferred()


func _on_settings_pressed() -> void:
	SceneManager.change_scene("uid://cjp5pyapkg5py")


func _on_play_pressed() -> void:
	SceneManager.change_scene("uid://bojbxy80uap6s")
