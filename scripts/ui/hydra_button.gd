extends Button

@onready var click_sound: AudioStreamPlayer = $ClickSound

func _on_pressed() -> void:
	click_sound.play()
