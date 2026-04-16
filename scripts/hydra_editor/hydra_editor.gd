extends GraphEdit

@onready var connection_layer = get_node("_connection_layer")


var last_zoom := zoom
var network_handler := NetworkHandler.new()

var devices: Dictionary[String, BaseNode]
var ui_connections: Array = []


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if zoom != last_zoom:
		_update_lines_zoom()
		
func _update_lines_zoom():
	connection_layer.scale = Vector2(zoom, zoom)
	last_zoom = zoom	

func _get_port_anchor(node: BaseNode, port_idx: int) -> Vector2:
	var port = node.get_port_position(port_idx)
	return node.position_offset + port * (1/zoom)

func _update_line(data):
	var line = data["line"]
	line.clear_points()
	
	var from_pos = _get_port_anchor(data["from_node"], data["from_port"])
	var to_pos = _get_port_anchor(data["to_node"], data["to_port"])
	
	line.add_point(from_pos)
	line.add_point(to_pos)

	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.has("node_path") and data["node_path"]
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	add_device(at_position, data)


func add_connection(from: BaseNode, from_port: int, to: BaseNode, to_port: int):
	var line = Line2D.new()
	line.antialiased = true
	line.width = 5
	line.default_color = Color.DIM_GRAY
	
	connection_layer.add_child(line)
	
	var data = {
		"line": line,
		"from_node": from,
		"to_node": to,
		"from_port": from_port,
		"to_port": to_port
	}
	
	ui_connections.append(data)
	
	from.position_offset_changed.connect(func(): _update_line(data))
	to.position_offset_changed.connect(func(): _update_line(data))
	
	_update_line(data)
	
	network_handler.add_connection(
		from.mac_address,
		to.mac_address,
		from_port,
		to_port
	)

func remove_connection_by_device(device: BaseNode):
	for i in range(ui_connections.size() - 1, -1, -1):
		var con = ui_connections[i]
		
		if con["from_node"] == device or con["to_node"] == device:
			
			network_handler.remove_connection(
				con["from_node"].mac_address,
				con["from_port"]
			)
			
			con["line"].queue_free()
			ui_connections.remove_at(i)

func add_device(at_position: Vector2, data: Dictionary):
	var scene = load(data["node_path"])
	var node = scene.instantiate() as BaseNode
	
	devices[node.mac_address] = node
	network_handler.add_device(data["type"], node.mac_address, node.n_ports)
	
	
	add_child(node)
	node.position_offset = at_position
	
func remove_device(device: BaseNode):
	
	remove_connection_by_device(device)
	
	network_handler.remove_device(device.mac_address)
	devices.erase(device.mac_address)
	device.queue_free()
	


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in get_children():
		if node.name in nodes:
			remove_device(node)
