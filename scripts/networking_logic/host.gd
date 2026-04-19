extends Device
class_name Host

var template = "[color=green]Packet received from {0} with id {1}.[/color]"
signal packet_recieved(packet: Packet)

func receive_packet(packet:Packet, port:Port, _from_mac: String):
	packet_arrived.emit(_from_mac, mac_address)
	
	if packet.destination in [mac_address, "broadcast"]:
		print_rich(template.format([packet.origin, packet.id]))
		packet_recieved.emit(packet)
	
func send_packet(packet: Packet):
	for p in ports:
		if p.link:
			p.send_packet(packet)
			return
