extends GraphEdit


var clip_board:Array[Node]
var last_pasted: Array[Node]

func get_selected_nodes() -> Array[Node]:
	var selected_nodes: Array[Node] = []
	for node in get_children():
		if node is GraphNode and node.selected:
			selected_nodes.append(node)
			
	return selected_nodes

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_copy_nodes_request() -> void:
	clip_board = get_selected_nodes()
	

func _on_paste_nodes_request() -> void:
	if clip_board.is_empty():
		return
	
	last_pasted.map(func (node): node.selected = false)
	last_pasted = []
	
	var reference_pos = clip_board[0].position_offset
	var mouse_pos = get_local_mouse_position()

	for node in clip_board:
		node.selected = false
		
		var copy_node = node.duplicate()
		add_child(copy_node)
		
		var offset_from_reference = node.position_offset - reference_pos
		copy_node.position_offset = mouse_pos + offset_from_reference
		
		copy_node.selected = true
		
		last_pasted.append(copy_node)


func _on_duplicate_nodes_request() -> void:
	_on_copy_nodes_request()
	_on_paste_nodes_request()

func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for child in get_children():
		if child.name in nodes:
			child.queue_free.call_deferred()
