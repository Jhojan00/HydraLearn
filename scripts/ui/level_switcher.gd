extends PanelContainer

@onready var switcher: Switcher = $Switcher
@export var levels: Array[LevelData] = []
@export var containers: Array[PanelContainer] = []
@export var unselected: Texture2D
@export var selected: Texture2D

func _ready() -> void:
	switcher.content = levels
	_select(switcher.idx)

func _select(idx: int) -> void:
	var container := containers[idx]
	var data := levels[idx]
	container.size_flags_vertical = Control.SIZE_FILL
	container.get("theme_override_styles/panel").texture = selected
	get_node(data.character_path).play("yes")

func _unselect(idx: int) -> void:
	var container := containers[idx]
	container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	container.get("theme_override_styles/panel").texture = unselected

func right() -> void:
	_unselect(switcher.idx)
	switcher.right()
	_select(switcher.idx)

func left() -> void:
	_unselect(switcher.idx)
	switcher.left()
	_select(switcher.idx)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		right()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("left"):
		left()
		get_viewport().set_input_as_handled()

func _on_play_pressed() -> void:
	var data: LevelData = switcher.get_item()
	if data and not data.scene_uid.is_empty():
		SceneManager.change_scene(data.scene_uid)
	else:
		push_warning("No scene UID for level at idx:%d" % switcher.idx)
