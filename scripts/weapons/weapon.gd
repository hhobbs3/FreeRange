extends Node2D
class_name Weapon2D

@export var speed = 1000
@export var weapon_sprite : Sprite2D
@export var can_attack = true
@export var attack_rate = 0.5
@export var sound_weapon : AudioStreamPlayer2D
@export var projectile : PackedScene
@export var projectile_point : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_facing_direction()
	if Input.is_action_just_pressed('horizontal_attack'):
		pass

func update_facing_direction():
	look_at(get_global_mouse_position())
	var relative_mouse_position = get_global_mouse_position() - global_position
	# Flip the Gun Sprite
	flip_sprite(relative_mouse_position.x)
	
func update_guard_direction():
	var weapon_position = global_position
	var relative_position = weapon_position - get_global_mouse_position()
	var x = 0
	var y = 0
	if abs(relative_position.x) > 10:
		x = -100 if relative_position.x > 10 else 100
	else:
		x = 0
	if abs(relative_position.y) > 10:
		y = -100 if relative_position.y > 10 else 100
	else:
		y = 0

	var guard_position = weapon_position + Vector2(x,y)
		
	look_at(guard_position)
	flip_sprite(relative_position.x * -1)

		
func flip_sprite(relative_position_x: int):
		# Flip the Weapon Sprite
	if relative_position_x > 0:
		weapon_sprite.flip_v = false
	elif relative_position_x < 0:
		weapon_sprite.flip_v = true
