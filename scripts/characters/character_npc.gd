extends CharacterBody2D
class_name CharacterNPC

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player = $"../../Player"

@export var speed : float
@export var jump_velocity : float
@export var max_flaps: int
@export var flap_force: float = 100.0

@export var health = 1

var head = 'idle'
var has_collided_with_player = false;
var flap_count = 0 
var player_position
var target_position

func _physics_process(delta):
	pass
	
