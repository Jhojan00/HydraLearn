extends Node
class_name NetworkHandler

var connections: Array
var devices: Dictionary[String, Device]

var _classes_map := {
	"host" : Host,
	"switch" : Switch
}

func add_device(type:String, id:String, n_ports: int):
	if _classes_map.get(type):
		var new_device = _classes_map[type].new() as Device
		new_device.mac_address = id
		
		for _i in range(n_ports):
			new_device.add_port(Port.new())
		
		devices[id] = new_device
		
	else:
		push_warning("There is no device for %s." % type)
	
func add_connection(emisor_id: String, receptor_id: String, from_port_idx: int, to_port_idx: int):
	if devices.get(emisor_id) and devices.get(receptor_id):
		
		var emisor = devices[emisor_id] as Device
		var receptor = devices[receptor_id] as Device
		
		var link_con = Link.new()
		link_con.port_a = emisor.ports[from_port_idx]
		link_con.port_b = receptor.ports[to_port_idx]
		
		emisor.ports[from_port_idx].link = link_con
		receptor.ports[to_port_idx].link = link_con
		
		connections.append(link_con)

	else:
		push_warning("Id of device not found.")

func remove_connection(device_id: String, port_idx: int):
	if devices.get(device_id):
		
		var device = devices[device_id] as Device
		var link = device.ports[port_idx].link
		connections.remove_at(connections.find(link))

	else:
		push_warning("Id of device not found.")
