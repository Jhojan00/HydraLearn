extends TextureRect
class_name PortView

const HEXAGON_SWITCH = preload("uid://b6apugqsfgiga")

var index: int
var device_node: BaseNode
var busy := false

signal port_connected(from: BaseNode, from_port: int, to: BaseNode, to_port: int)

	
func _get_drag_data(at_position: Vector2) -> Variant:
	var data = {
		"type" : "connection",
		"port" : index,
		"device_node": device_node,
		"busy" : busy
	}
	
	var preview_image = TextureRect.new()
	preview_image.texture = HEXAGON_SWITCH
	preview_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	preview_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_image.custom_minimum_size = Vector2(30, 30)
	
	
	set_drag_preview(preview_image)
	
	return data
	

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data["type"] == "connection" and not busy\
	 and not data["busy"] and data["device_node"] != device_node
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	port_connected.emit(data["device_node"], data["port"], device_node, index)
