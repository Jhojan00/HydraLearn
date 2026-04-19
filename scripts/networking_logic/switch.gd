extends Device
class_name Switch

var cam_table:Dictionary[String, Port] = {}

func flooding(packet:Packet, port:Port):
	for p in ports:
		if p != port:
			p.send_packet(packet)
			

func receive_packet(packet:Packet, port:Port, _from_mac: String):
	packet_arrived.emit(_from_mac, mac_address)
	cam_table[packet.origin] = port
	
	if packet.destination == "broadcast":
		flooding(packet, port)
	elif packet.destination in cam_table:
		cam_table[packet.destination].send_packet(packet)
	else:
		flooding(packet, port)
