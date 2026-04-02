extends Node
## Base device for hosts, switches, etc.
class_name Device

var mac_address: String
var ports: Array[Port]

func add_port(port:Port):
	port.packet_received.connect(receive_packet)
	ports.append(port)

func receive_packet(_packet:Packet, _port:Port):
	pass # Process.
	
func direct_packet(port:Port, packet:Packet):
	port.send_packet(packet)
