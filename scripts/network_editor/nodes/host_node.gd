extends GraphNode

@onready var port_reference_start: Control = $port_reference_start
@onready var swap: Button = $Swap

@export var n_ports: int = 5

var ports_index:Array
var right := true
var logical_ports: Array[Port]

func _ready() -> void:
	swap.pressed.connect(swap_ports)
	

func inicializate():
	create_ports()

func clear_ports() -> void:
	right = true
	ports_index.clear()
	for node in get_children():
		if node.is_in_group("Ports"):
			node.queue_free()
			
func create_ports():
	for n in range(n_ports + 1, port_reference_start.get_index(), -1):
		var port = Control.new()
		port.mouse_filter = Control.MOUSE_FILTER_PASS
		port.custom_minimum_size = Vector2(20, 20)
		port.add_to_group("Ports")
		port_reference_start.add_sibling(port)
		
		ports_index.append(n)
		
		set_slot(n, not right, 0, Color.INDIGO, right, 0, Color.WHITE)
	
	create_logical_ports()

func swap_ports() -> void:
	right = not right
	for p_idx in ports_index:
		set_slot(p_idx, not right, 0, Color.INDIGO, right, 0, Color.WHITE)
		
		
func create_logical_ports():
	for p_idx in ports_index:
		var l_port = Port.new()
		get_child(p_idx).add_child(l_port)
		
func get_port_by_idx(relative_idx:int):
	# A relative index is the index given by the GraphEdit node.
	return get_child(ports_index[relative_idx]).get_child(0)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print(data)
	return true
