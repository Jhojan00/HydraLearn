extends Line2D
class_name LineView

signal deleted(line:LineView)

func _ready() -> void:
	antialiased = true
	width = 5

func _input(event: InputEvent) -> void:
	if event.is_action("click") and event.pressed:
		var P = event.position
		
		for i in range(points.size() - 1):
			var A = points[i]
			var B = points[i + 1]

			var closest = Geometry2D.get_closest_point_to_segment(P, A, B)
			var distance = P.distance_to(closest)

			if distance < width:
				line_clicked()
				break
				
func line_clicked():
	if State.get_mode() == State.MODES.DELETE:
		print("AAAAA")
		deleted.emit(self)
