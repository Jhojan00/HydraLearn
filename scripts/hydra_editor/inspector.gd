extends PanelContainer
class_name Inspector

@onready var name_edit: LineEdit = %NameEdit
@onready var message_edit: LineEdit = %MessageEdit
@onready var target_edit: LineEdit = %TargetEdit
@onready var mac_edit: LineEdit = %MacEdit
@onready var ports_edit: LineEdit = %PortsEdit


@onready var interaction_container: VBoxContainer = %"InteractionContainer"
@onready var error_label: Label = %ErrorLabel

var can_send := true

signal send_message
signal name_changed(new_name: String)



func _on_send_pressed() -> void:
	if (message_edit.text.is_empty() or target_edit.text.is_empty()):
		error_label.show()
		return
	
	error_label.hide()
	
	send_message.emit()
	
	hide()

func _on_copy_mac_pressed() -> void:
	DisplayServer.clipboard_set(mac_edit.text)

func update_inspector(device: String, n_ports: int, mac_address: String, can_send_messages: bool):
	
	for con in name_changed.get_connections():
		name_changed.disconnect(con["callable"])
	
	for con in send_message.get_connections():
		send_message.disconnect(con["callable"])
	
	name_edit.text = device
	ports_edit.text = str(n_ports)
	mac_edit.text = mac_address
	can_send = can_send_messages
	
	interaction_container.visible = can_send


func _on_name_edit_text_changed(new_text: String) -> void:
	name_changed.emit(new_text)
