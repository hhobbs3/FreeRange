extends Node2D
class_name Weapon2D

@export var speed = 1000
@export var weapon_sprite : Sprite2D
@export var can_fire = true
@export var fire_rate = 0.5
@export var sound_weapon : AudioStreamPlayer2D
@export var projectile : PackedScene
@export var projectile_point : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_facing_direction():
	look_at(get_global_mouse_position())
	var relative_mouse_position = get_global_mouse_position() - global_position
	# Flip the Gun Sprite
	if relative_mouse_position.x > 0:
		weapon_sprite.flip_v = false
	elif relative_mouse_position.x < 0:
		weapon_sprite.flip_v = true
