extends HBoxContainer

@onready var switcher: Switcher = $Switcher
@onready var flag: TextureRect = $Flag

var languages_textures : Dictionary[String, Texture2D] = {
	"en" : preload("uid://ce853fuvlluf"),
	"es" : preload("uid://147raxarcrug")
}
var system_language = TranslationServer.get_locale()


func _ready() -> void:
	switcher.content = languages_textures.keys()
	switcher.custom_select_item(system_language)
	
	update_language()

func _on_right_pressed() -> void:
	switcher.right()
	update_language()

func _on_left_pressed() -> void:
	switcher.left()
	update_language()
	
func update_language():
	flag.texture = languages_textures.values()[switcher.idx]
	TranslationServer.set_locale(switcher.get_item())
