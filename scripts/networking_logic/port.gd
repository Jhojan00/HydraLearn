extends Node
class_name Port

signal packet_received(packet:Packet, port:Port, from_mac: String)

var link: Link
var owner_mac: String

func send_packet(packet:Packet):
	if link:
		link.send_packet(packet, self)
	else:
		push_warning("There is no link to send the data through.")
	
func receive_packet(packet:Packet, from_mac: String):
	packet_received.emit(packet, self, from_mac)
