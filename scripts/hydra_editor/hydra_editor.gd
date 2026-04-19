extends GraphEdit

@onready var connection_layer = get_node("_connection_layer")

const LINE = preload("uid://dkqfa3fjaohj7")

var last_zoom := zoom
var network_handler := NetworkHandler.new()

var devices: Dictionary[String, BaseNode]
var ui_connections: Array = []

func _ready() -> void:
	randomize()

func _process(_delta: float) -> void:
	if zoom != last_zoom:
		_update_lines_zoom()
		
func _update_lines_zoom():
	connection_layer.scale = Vector2(zoom, zoom)
	last_zoom = zoom	

func _get_port_anchor(node: BaseNode, port_idx: int) -> Vector2:
	var pos = (node.get_port_position(port_idx) + scroll_offset - global_position) / zoom
	return pos

func _update_line(data):
	if not is_instance_valid(data["line"]):
			return
		
	if not is_instance_valid(data["from_node"]) or not is_instance_valid(data["to_node"]):
		return

	var line = data["line"]
	line.clear_points()
	
	var from_pos = _get_port_anchor(data["from_node"], data["from_port"])
	var to_pos = _get_port_anchor(data["to_node"], data["to_port"])
	
	line.add_point(from_pos)
	line.add_point(to_pos)

func _on_node_moved():
	for con in ui_connections:
		_update_line(con)
			
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data["type"] == "device" and data.has("node_path")
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	add_device(at_position, data)


func add_connection(from: BaseNode, from_port: int, to: BaseNode, to_port: int):
	var line = LINE.instantiate() as LineView
	var color = Color(randf_range(0.5, 0.8), randf_range(0.5, 0.8), randf_range(0.5, 0.8),)
	
	line.default_color = color
	line.deleted.connect(remove_connection_by_line)
	
	connection_layer.add_child(line)
	
	var data = {
		"line": line,
		"from_node": from,
		"to_node": to,
		"from_port": from_port,
		"to_port": to_port,
	}
	
	ui_connections.append(data)

	_update_line(data)
	
	network_handler.add_connection(
		from.mac_address,
		to.mac_address,
		from_port,
		to_port
	)
	
	
	from.set_port_status(from_port, true, color)
	to.set_port_status(to_port, true, color)


func remove_connection_by_device(device: BaseNode):
	for i in range(ui_connections.size() - 1, -1, -1):
		var con = ui_connections[i]
		
		if con["from_node"] == device or con["to_node"] == device:
			
			network_handler.remove_connection(
				con["from_node"].mac_address,
				con["from_port"]
			)
			
			var from_node = con["from_node"]
			var to_node = con["to_node"]

			if is_instance_valid(from_node):
				from_node.set_port_status(con["from_port"], false)


			if is_instance_valid(to_node):
				to_node.set_port_status(con["to_port"], false)

			
			if con["line"]:
				con["line"].queue_free()
				ui_connections.remove_at(i)

func remove_connection_by_line(line: LineView) -> void:
	for i in range(ui_connections.size() - 1, -1, -1):
		var con = ui_connections[i]
		
		if con["line"] == line:
			
			network_handler.remove_connection(
				con["from_node"].mac_address,
				con["from_port"]
			)
			
			var from_node = con["from_node"]
			var to_node = con["to_node"]

			if is_instance_valid(from_node):
				from_node.set_port_status(con["from_port"], false)

			if is_instance_valid(to_node):
				to_node.set_port_status(con["to_port"], false)

			if is_instance_valid(line):
				line.queue_free()

			ui_connections.remove_at(i)
			return

func add_device(at_position: Vector2, data: Dictionary):
	var scene = load(data["node_path"])
	var node = scene.instantiate() as BaseNode
	
	devices[node.mac_address] = node
	network_handler.add_device(data["device_type"], node.mac_address, node.n_ports)
	
	
	add_child(node)
	node.position_offset = (at_position - global_position + scroll_offset) / zoom
	node.port_connected.connect(add_connection)
	node.position_offset_changed.connect(_on_node_moved)
	node.deleted.connect(remove_device)
	
func remove_device(device: BaseNode):
	remove_connection_by_device(device)
	
	network_handler.remove_device(device.mac_address)
	devices.erase(device.mac_address)
	device.queue_free()
	
	


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in get_children():
		if node.name in nodes:
			remove_device(node)
