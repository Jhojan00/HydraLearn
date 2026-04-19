extends GraphEdit

@onready var connection_layer = get_node("_connection_layer")
@onready var inspector: Inspector = $Inspector
@onready var network_handler: NetworkHandler = $NetworkHandler
@onready var arrived_dialog: AcceptDialog = $ArrivedDialog

const LINE = preload("uid://dkqfa3fjaohj7")

var last_zoom := zoom
var devices: Dictionary[String, BaseNode]
var ui_connections: Array = []
var line_animation_queue: Array[Dictionary] = []
var animating = false
var arrived = false

func _ready() -> void:
	randomize()

func _process(_delta: float) -> void:
	if zoom != last_zoom:
		_update_lines_zoom()
	

#region Lines

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

	var line = data["line"] as LineView
	line.clean()
	
	var from_pos = _get_port_anchor(data["from_node"], data["from_port"])
	var to_pos = _get_port_anchor(data["to_node"], data["to_port"])
	
	line.add_curve_point(from_pos)
	line.add_curve_point(to_pos)
	
	line.sync_position()

func _on_node_moved():
	for con in ui_connections:
		_update_line(con)

func _get_connection(a: String, b: String):
	for con in ui_connections:
		var fa = con["from_node"].mac_address
		var fb = con["to_node"].mac_address

		if (fa == a and fb == b) or (fa == b and fb == a):
			return con


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

func find_line_by_macs(from_mac: String, to_mac: String) -> LineView:
	for con in ui_connections:
		var from_node = con["from_node"]
		var to_node = con["to_node"]

		if not is_instance_valid(from_node) or not is_instance_valid(to_node):
			continue

		var a = from_node.mac_address
		var b = to_node.mac_address

		if (a == from_mac and b == to_mac) or (a == to_mac and b == from_mac):
			return con["line"]

	return null

func start_animating():
	animating = true
	
	while line_animation_queue:
		var data = line_animation_queue.pop_front()

		var line = data["line"]
		var from_mac = data["from"]
		var to_mac = data["to"]

		var con = _get_connection(from_mac, to_mac)
		if con:
			var is_forward = con["from_node"].mac_address == from_mac

			if is_forward:
				line.start_sending(0.0, 1.0)
			else:
				line.start_sending(1.0, 0.0)

			await line.anim_finished

	animating = false
	
	if arrived:
		arrived_dialog.show()	
		arrived = false

#endregion Lines

#region Devices

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

#endregion Devices

#region Interaction

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data["type"] == "device" and data.has("node_path")
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	add_device(at_position, data)

func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in get_children():
		if node.name in nodes:
			remove_device(node)


func _on_node_selected(node: Node) -> void:
	if State.get_mode() != State.MODES.DELETE:
		node = node as BaseNode

		for n in devices.values():
			if n.selected and node != n:
				return
		
		inspector.show()
		node.build_inspector(inspector)

func _on_node_deselected(node: Node) -> void:
	inspector.hide()

#endregion Interaction

#region Packets


	

func _on_inspector_send_message(origin_mac: String, destination_mac: String, data: String) -> void:
	print("Sending message!")
	network_handler.send_packet(origin_mac, destination_mac, data)

func _on_network_handler_packet_arrived_device(from_mac: String, to_mac: String) -> void:
	var line = find_line_by_macs(from_mac, to_mac)
	line_animation_queue.append({
	"line": line,
	"from": from_mac,
	"to": to_mac
	})
	
	if not animating:
		start_animating()

func _on_network_handler_packet_recieved(packet: Packet) -> void:
	arrived_dialog.dialog_text = """
	Packet id: %d
	Byte Content: %s
	Content: %s
	From mac: %s
	""" % [
		packet.id,
		str(packet.content),
		packet.content.get_string_from_utf8(),
		packet.origin
		]
		
	arrived = true

#endregion Packets
