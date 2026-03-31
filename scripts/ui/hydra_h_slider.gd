extends HSlider
@onready var moved: AudioStreamPlayer = $Moved


func _on_drag_ended(value_changed: bool) -> void:
	if value_changed:
		moved.play()


func _on_drag_started() -> void:
	moved.play()
