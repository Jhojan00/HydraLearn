extends GraphElement
class_name BaseNode

@export var selected_color: Color = Color(0.22, 0.2, 0.2, 0.6)
@export var normal_color: Color = Color(0.1, 0.1, 0.1, 0.6)

@onready var bg: PanelContainer = $BG

func _ready() -> void:
	var new_style = StyleBoxFlat.new()
	new_style.bg_color = normal_color
	new_style.set_corner_radius_all(10)
	
	bg.add_theme_stylebox_override("panel", new_style)

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
	
func _on_node_deselected() -> void:
	_change_color(normal_color)
