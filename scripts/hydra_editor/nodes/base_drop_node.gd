extends TextureRect


@export var node_path: String
@export var type: String

func _get_drag_data(at_position: Vector2) -> Variant:
	
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = size
	
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	
	return {"node_path": node_path, "type": type}
