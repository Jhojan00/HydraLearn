extends GraphEdit

@onready var links: Node = $Links

var clipboard = []
var links_array: Array[Link] = []
var bussy_ports: Array[Port] = []

func get_selected_nodes() -> Array[GraphElement]:
	var selected_nodes:Array[GraphElement] = []
	for node in get_children():
		if node is GraphElement and node.selected:
			selected_nodes.append(node)
			
	return selected_nodes

func get_node_by_name(n_name:String):
	for node in get_children():
		if node.name == n_name:
			return node

#region Signals

func _on_copy_nodes_request() -> void:
	clipboard.clear()
	
	var selected = get_selected_nodes()
	if selected.is_empty():
		return
	
	var reference_pos = selected[0].position_offset
	
	for node in selected:
		clipboard.append({
			"scene": node,
			"offset": node.position_offset - reference_pos
		})

func _on_paste_nodes_request() -> void:
	if clipboard.is_empty():
		return
	
	var mouse_pos = (get_local_mouse_position() + scroll_offset) / zoom
	
	for data in clipboard:
		var original = data["scene"]
		var offset = data["offset"]
		
		original.selected = false
		
		var copy_node = original.duplicate()
		add_child(copy_node)
		
		copy_node.clear_ports()
		
		await get_tree().process_frame
		
		copy_node.create_ports()
		
		copy_node.position_offset = mouse_pos + offset
		copy_node.selected = true

func _on_duplicate_nodes_request() -> void:
	# HACK: Improve this implementation to avoid pasting it in the mouse position.
	_on_copy_nodes_request()
	_on_paste_nodes_request()


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	var selected_nodes = get_selected_nodes()
	for node in selected_nodes:
		node.queue_free.call_deferred()	
		

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var l_port_a = get_node_by_name(from_node).get_port_by_idx(from_port) as Port
	var l_port_b = get_node_by_name(to_node).get_port_by_idx(to_port) as Port
	
	if (from_node != to_node) \
	and (l_port_a not in bussy_ports) \
	and (l_port_b not in bussy_ports):
		
		var l_link = Link.new()
		
		l_link.port_a = l_port_a
		l_link.port_b = l_port_b
		
		l_port_a.link = l_link
		l_port_b.link = l_link
		
		links_array.append(l_link)
		links.add_child(l_link)
		
		bussy_ports.append_array([l_port_a, l_port_b])
		
		connect_node(from_node, from_port, to_node, to_port)
		
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var l_port_a = get_node_by_name(from_node).get_port_by_idx(from_port) as Port
	var l_port_b = get_node_by_name(to_node).get_port_by_idx(to_port) as Port

	var link_idx = links_array.find(l_port_a.link)
	
	links_array[link_idx].queue_free()
	links_array.remove_at(link_idx)
	
	bussy_ports.remove_at(bussy_ports.find(l_port_a))
	bussy_ports.remove_at(bussy_ports.find(l_port_b))
	
	disconnect_node(from_node, from_port, to_node, to_port)
	
#endregion Signals

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is PackedScene
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var scene = data as PackedScene
	var instance = scene.instantiate()
	add_child(instance)
	instance.position_offset = at_position
	instance.inicializate()


func _on_back_pressed() -> void:
	SceneManager.change_scene("uid://bojbxy80uap6s", {"pattern":"squares", "color":Color.BLACK})
