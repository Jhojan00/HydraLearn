extends GraphEdit

@onready var conection_layer = get_node("_connection_layer")
@onready var graph_element: GraphElement = $GraphElement
@onready var graph_element_2: GraphElement = $GraphElement2


var last_zoom := zoom


func _ready() -> void:
	add_conection(graph_element, graph_element_2)
	
	

func _process(delta: float) -> void:
	if zoom != last_zoom:
		_update_lines_zoom()
		

func _update_lines_zoom():
	conection_layer.scale = Vector2(zoom, zoom)
	last_zoom = zoom	

func _update_lines_pos(line: Line2D, from: BaseNode, to: BaseNode):
	line.clear_points()
	
	var from_center =  get_port_anchor(from)
	var to_center = get_port_anchor(to)
	_add_points(line, from_center, to_center)

func _add_points(line: Line2D, from: Vector2, to: Vector2):
	line.add_point(from)
	line.add_point(to)

func add_conection(from: BaseNode, to: BaseNode):
	var line = Line2D.new()
	
	line.antialiased = true
	line.width = 5
	line.default_color = Color.DIM_GRAY
	
	from.position_offset_changed.connect(func(): _update_lines_pos(line, from, to))
	to.position_offset_changed.connect(func(): _update_lines_pos(line, to, from))

	
	conection_layer.add_child(line)
	
	_update_lines_pos(line, from, to)

func remove_connection():
	pass

func get_port_anchor(node: BaseNode) -> Vector2:
	var vector_anchor = node.position_offset + node.get_global_rect().size * Vector2(0.5, 0.85) * (1/zoom)
	return vector_anchor
