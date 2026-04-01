extends Node
class_name Link

var latency: float
var loss_probability: float
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
		var from_port = request["from_port"]
		var packet = request["packet"]
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
			target_port.receive_packet(packet)
			packet_sent.emit(packet)
	waiting = false
