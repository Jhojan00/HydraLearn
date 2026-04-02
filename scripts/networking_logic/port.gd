extends Node
class_name Port

signal packet_received(packet:Packet, port:Port)

var link: Link

func send_packet(packet:Packet):
	if link:
		link.send_packet(packet, self)
	else:
		push_warning("There is no link to send the data through.")
	
func receive_packet(packet:Packet):
	packet_received.emit(packet, self)
