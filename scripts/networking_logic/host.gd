extends Device
class_name Host

var template = "[color=green]Packet received from {0} with id {1}.[/color=green]"

func receive_packet(packet:Packet, port:Port):
	if packet.destination in [mac_address, "broadcast"]:
		print_rich(template.format([packet.origin, packet.id]))		
