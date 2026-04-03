extends TextureRect

@export var instance:PackedScene

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30, 30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	return instance
