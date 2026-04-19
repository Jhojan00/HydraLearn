extends Node
## Base device for hosts, switches, etc.
class_name Device

var mac_address: String
var ports: Array[Port]

signal packet_arrived(from_mac:String, to_mac:String)

func add_port(port:Port):
	port.packet_received.connect(receive_packet)
	port.owner_mac = mac_address
	ports.append(port)

func receive_packet(_packet:Packet, _port:Port, _from_mac: String):
	pass
	
func direct_packet(port:Port, packet:Packet):
	port.send_packet(packet)
