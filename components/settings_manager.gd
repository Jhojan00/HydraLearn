extends Node
class_name SettingsManager

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	DisplayServer.screen_get_size()
]

var window_modes = [
	DisplayServer.WINDOW_MODE_MAXIMIZED,
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
]

var window_modes_str = [
	"K_VIDEO_WINDOW_MODE_MAXIMIZED",
	"K_VIDEO_WINDOW_MODE_WINDOWED",
	"K_VIDEO_WINDOW_MODE_FULLSCREEN",
]

var current_res_idx = 2

var current_win_idx = 0

func change_resolution(idx: int):
	if resolutions.get(idx):
		DisplayServer.window_set_size(resolutions[idx])

func resolutions_to_string():
	return resolutions.map(func (e): return "%d x %d" % [e.x, e.y])
	
func change_volume(value:float, bus_name:String):
	var bus = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))

func change_win_mode(idx):
	if window_modes.get(idx):
		DisplayServer.window_set_mode(window_modes[idx])
		
func win_modes_to_string():
	return window_modes_str
	
