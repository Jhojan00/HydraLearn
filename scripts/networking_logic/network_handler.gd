extends Node
class_name NetworkHandler

var connections: Array
var devices: Dictionary[String, Device]

var _classes_map := {
	"host" : Host,
	"switch" : Switch
}

func add_device(type:String, mac_address: String, n_ports: int):
	if _classes_map.get(type):
		var new_device = _classes_map[type].new() as Device
		new_device.mac_address = mac_address
		
		for _i in range(n_ports):
			new_device.add_port(Port.new())
		
		devices[mac_address] = new_device
		
	else:
		push_warning("There is no device for %s." % type)

func remove_device(mac_address: String):
	if not devices.get(mac_address):
		push_warning("Id of device not found.")
		return
	
	var device = devices[mac_address] as Device
	for port in device.ports:
		if port.link:
			var link = port.link
			var other_port = link.port_a if link.port_b == port else link.port_b
			
			if other_port:
				other_port.link = null
			
			port.link = null
			
			var idx = connections.find(link)
			if idx != -1:
				connections.remove_at(idx)
				
	devices.erase(mac_address)

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
		
func send_packet(device, mac_address):
	pass
