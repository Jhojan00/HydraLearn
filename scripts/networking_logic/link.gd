extends Node
class_name Link

var latency: float = 0.2
var loss_probability: float = 0
var port_a: Port
var port_b: Port

var waiting_queue: Array
var waiting = false


signal packet_lost(packet:Packet)
signal packet_sent(packet:Packet)


func send_packet(packet:Packet, from_port:Port):
	waiting_queue.append({"packet": packet, "from_port": from_port})
	if not waiting:
		start_sending()
		
func start_sending():
	waiting = true
	while waiting_queue:
		var request = waiting_queue.pop_front()
		var from_port: Port = request["from_port"]
		var packet: Packet = request["packet"].duplicate()
		var target_port: Port = null
		
		await get_tree().create_timer(latency).timeout
		
		
		if randf() < loss_probability:
			packet_lost.emit(packet)
			
		elif from_port == port_a:
			target_port = port_b
			
		elif from_port == port_b:
			target_port = port_a
			
		else:
			push_warning("Port not found, check if both ports are connected.")
			
		if target_port != null:
			packet.ttl -= 1
			if packet.ttl <= 0:
				packet_lost.emit(packet)
			else:
				target_port.receive_packet(packet)
				packet_sent.emit(packet)
	waiting = false
