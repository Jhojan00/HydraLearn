extends PanelContainer

@onready var switcher: Switcher = $Switcher # HACK -> Change this logic to a switcher :)

@export var containers : Array[PanelContainer] = []
@export var unselected: Texture2D
@export var selected: Texture2D

var selected_idx:int = 0
var levels = [
	"uid://bp5rqfllau2l3",
]

func select(container:PanelContainer):
	container.size_flags_vertical = Control.SIZE_FILL
	container.get("theme_override_styles/panel").texture = selected
	
	var character = container.get_node(container.get_meta("character"))
	
	character.play("yes")
	
func unselect(container:PanelContainer):
	container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	container.get("theme_override_styles/panel").texture = unselected

func right():
	if selected_idx + 1 < len(containers):
		selected_idx += 1
		
		unselect(containers[selected_idx-1])
		select(containers[selected_idx])

func left():
	if selected_idx - 1 > -1:
		selected_idx -= 1
			
		unselect(containers[selected_idx+1])
		select(containers[selected_idx])
		
func _ready() -> void:
	select(containers[selected_idx])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		right()
		get_viewport().set_input_as_handled()
			
	elif event.is_action_pressed("left"):
		left()
		get_viewport().set_input_as_handled()


func _on_play_pressed() -> void:
	var level = levels.get(selected_idx)
	if level:
		SceneManager.change_scene(level)
	else:
		push_warning("There is no level for idx:%d yet!" % selected_idx)
	
