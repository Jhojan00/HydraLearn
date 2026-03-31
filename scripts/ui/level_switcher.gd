extends PanelContainer

@export var containers : Array[PanelContainer] = []
@export var unselected: Texture2D
@export var selected: Texture2D


var selected_idx:int = 0

func select(container:PanelContainer):
	container.size_flags_vertical = Control.SIZE_FILL
	container.get("theme_override_styles/panel").texture = selected
	
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
			
	elif event.is_action_pressed("left"):
		left()
