extends Control

@onready var tutorial: PanelContainer = $Tutorial

const HYDRA_BALLON = preload("uid://cvwh447ottsb3")
const ARROW_DECORATIVE_E_SMALL = preload("uid://cyocq0nqvmqko")

const dialogs = [
	preload("res://dialogs/p1_switch_host.dialogue"),
	preload("res://dialogs/p2_connect_devices.dialogue"),
	preload("uid://cwcawomktam8s"),
	preload("res://dialogs/p4_tool_bar.dialogue"),
	preload("res://dialogs/p5_send_packets.dialogue"),
	preload("res://dialogs/finish.dialogue"),
]

func _ready() -> void:
	var resource = load("uid://cq2rtd753sq4t")
	DialogueManager.show_dialogue_balloon_scene(HYDRA_BALLON, resource)
	
func _play_dialog(idx: int):
	DialogueManager.show_dialogue_balloon_scene(HYDRA_BALLON, dialogs[idx])
	
