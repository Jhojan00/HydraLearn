extends GraphElement
class_name BaseNode

@export var sprite: Texture2D
@export var mac_address: String = create_mac_address()
@export var n_ports: int = 4

@export_group("Selection")
@export var selected_color: Color = Color(0.22, 0.2, 0.2, 0.6)
@export var normal_color: Color = Color(0.1, 0.1, 0.1, 0.6)

@onready var bg: PanelContainer = $BG
@onready var ports_container: HBoxContainer = %PortsContainer
@onready var name_edit: LineEdit = %NameEdit

const PORT_VIEW = preload("uid://puy3jo5a3n6q")

signal port_connected(from: BaseNode, from_port: int, to: BaseNode, to_port: int)
signal deleted(node: BaseNode)


func _ready() -> void:
	var new_style = StyleBoxFlat.new()
	new_style.bg_color = normal_color
	new_style.set_corner_radius_all(10)
	
	bg.add_theme_stylebox_override("panel", new_style)
	
	_create_ports()
	


#region Style

func _change_color(color: Color):
	var bg_box = bg.get_theme_stylebox("panel") as StyleBoxFlat
	if bg_box:
		bg_box.bg_color = color
	else:
		var new_box = StyleBoxFlat.new()
		new_box.bg_color = color
		bg.add_theme_stylebox_override("panel", new_box)

func _on_node_selected() -> void:
	_change_color(selected_color)
	
	if State.get_mode() == State.MODES.DELETE:
		deleted.emit(self)
	
func _on_node_deselected() -> void:
	_change_color(normal_color)

#endregion Style

func _create_ports():
	for i in n_ports:
		var port_view = PORT_VIEW.instantiate() as PortView
		port_view.device_node = self
		port_view.index = i
		
		port_view.port_connected.connect(connection_started)
		
		ports_container.add_child(port_view)

func get_port_position(port_idx:int) -> Vector2:
	var port = ports_container.get_child(port_idx) as PortView
	
	return port.get_global_rect().get_center()

func set_port_status(port_idx:int, busy:bool, color:Color = Color.DEEP_SKY_BLUE):
	var port = ports_container.get_child(port_idx) as PortView
	port.modulate = color if busy else Color.WHITE
	
	port.busy = busy

func create_mac_address() -> String:
	var parts: Array[String] = []
	
	for i in 6:
		var byte = randi() % 256
		parts.append("%02X" % byte)
	
	return ":".join(parts)

func connection_started(from: BaseNode, from_port: int, to: BaseNode, to_port: int):
	port_connected.emit(from, from_port, to, to_port)

func update_name(new_name: String):
	name_edit.text = new_name	

func build_inspector(inspector:Inspector):
	pass
	
