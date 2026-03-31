extends HBoxContainer

@export var aviable_languages: Dictionary[String, Texture2D] = {}

@onready var flag: TextureRect = $Flag

var selected_idx = 0

func _ready() -> void:
	select_language()

func _on_right_pressed() -> void:
	if selected_idx + 1 < len(aviable_languages):
		selected_idx += 1
		flag.texture = aviable_languages.values()[selected_idx]
		TranslationServer.set_locale(aviable_languages.keys()[selected_idx])
		

func _on_left_pressed() -> void:
	if selected_idx - 1 > -1:
		selected_idx -= 1
		flag.texture = aviable_languages.values()[selected_idx]
		TranslationServer.set_locale(aviable_languages.keys()[selected_idx])
		
		
func select_language(lang: String = TranslationServer.get_locale()):
	if lang in aviable_languages:
		TranslationServer.set_locale(lang)
		flag.texture = aviable_languages[lang]
