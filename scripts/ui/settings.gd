extends Control

@onready var resolutions_button: OptionButton = $HBoxContainer/ConfigVideo/Container/MarginContainer/VBoxContainer/Resolution/ResolutionsButton

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	DisplayServer.screen_get_size()
]



func _ready() -> void:
	select_resolution()

func _on_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(resolutions_button.get_item_metadata(index))

func select_resolution():
	for idx in len(resolutions):
		var res = resolutions[idx]
		var label = str(res.x) + "x" + str(res.y)
		
		if idx == len(resolutions) - 1:
			label += " (Native)"
		
		resolutions_button.add_item(label)
		resolutions_button.set_item_metadata(idx, res)
	
	resolutions_button.select(len(resolutions)-1) # Select by default 1920 x 1080


func _on_back_pressed() -> void:
	SceneManager.change_scene("uid://dchlm4wvis2f3")


func _on_master_audio_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))

func _on_sounds_audio_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Sounds")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func _on_music_audio_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
