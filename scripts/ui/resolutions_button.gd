extends OptionButton

@onready var selected_sound: AudioStreamPlayer = $SelectedSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

func _on_item_selected(index: int) -> void:
	selected_sound.play()


func _on_pressed() -> void:
	click_sound.play()
