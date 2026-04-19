extends Line2D
class_name LineView

@onready var message_path: Path2D = $MessagePath
@onready var follow_message: PathFollow2D = $MessagePath/FollowMessage

var curve := Curve2D.new()
var send_tween: Tween

signal deleted(line:LineView)
signal anim_finished

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
		deleted.emit(self)

func clean():
	curve.clear_points()
	clear_points()
	
	message_path.curve = curve
	
	sync_position()

func add_curve_point(pos: Vector2):
	curve.add_point(pos)
	
func sync_position():
	points = curve.get_baked_points()
	message_path.curve = curve
	
func start_sending(start: float = 0.0, end: float = 1.0):	
	message_path.show()
	
	follow_message.progress_ratio = start
	
	send_tween = get_tree().create_tween()
	await send_tween.tween_property(
		follow_message,
		"progress_ratio",
		end,
		2
		).finished
	
	message_path.hide()
	
	anim_finished.emit()
