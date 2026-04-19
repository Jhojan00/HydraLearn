extends Node
class_name NetworkHandler

var connections: Array
var devices: Dictionary[String, Device]

var _classes_map := {
	"host" : Host,
	"switch" : Switch
}

signal packet_arrived_device(from_mac:String, to_mac: String)
signal packet_recieved(packet:Packet)


func add_device(type:String, mac_address: String, n_ports: int):
	if _classes_map.get(type):
		var new_device = _classes_map[type].new() as Device
		new_device.mac_address = mac_address
		new_device.packet_arrived.connect(
			func(from_mac, to_mac): packet_arrived_device.emit(from_mac, to_mac)
			)
			
		if new_device is Host:
			new_device.packet_recieved.connect(func(packet): packet_recieved.emit(packet))
		
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
		
func send_packet(origin_mac: String, destination_mac: String, data: String):
	if not devices.has(origin_mac):
		push_warning("Origin device not found.")
		return

	var host = devices[origin_mac] as Host

	var packet = Packet.new()
	packet.origin = origin_mac
	packet.destination = destination_mac
	packet.content = data.to_utf8_buffer()
	packet.id = randi()
	packet.ttl = 10

	host.send_packet(packet)
