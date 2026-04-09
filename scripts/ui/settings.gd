extends Control

@export var resolutions_button: OptionButton
@export var windows_button: OptionButton



var settings_manager = SettingsManager.new()

func _ready() -> void:
	resolutions_button.setup(
		settings_manager.resolutions_to_string(),
		settings_manager.current_res_idx
		)
	
	resolutions_button.item_selected.connect(settings_manager.change_resolution)
	
	windows_button.setup(
		settings_manager.win_modes_to_string(),
		settings_manager.current_win_idx
	)
	
	windows_button.item_selected.connect(settings_manager.change_win_mode)

func audio_changed(volume:float, bus:String):
	settings_manager.change_volume(volume, bus)
	
