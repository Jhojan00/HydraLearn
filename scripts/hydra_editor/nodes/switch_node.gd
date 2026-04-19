extends BaseNode


func _ready() -> void:
	super._ready()

func build_inspector(inspector:Inspector):
	inspector.update_inspector(name_edit.text, n_ports, mac_address, false)
	inspector.name_changed.connect(update_name)
	# inspector.send_message.connect()
	
