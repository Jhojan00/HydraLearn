extends CharacterBody2D
class_name BaseNPC

## If true physics are aplied to the character (velocity).
@export var physics:bool = false

@export_group("CharacterShape")
@export var body_texture: Texture2D
@export var face_texture: Texture2D
@export var hand_1_texture: Texture2D
@export var hand_2_texture: Texture2D


@onready var body: Sprite2D = $Body
@onready var face: Sprite2D = $Face
@onready var hand_2: Sprite2D = $Hand2
@onready var hand_1: Sprite2D = $Hand1



func _ready() -> void:
	body.texture = body_texture
	face.texture = face_texture
	hand_1.texture = hand_1_texture
	hand_2.texture = hand_2_texture
	

func _physics_process(delta: float) -> void:
	if physics:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
