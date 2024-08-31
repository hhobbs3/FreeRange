extends Node2D
class_name Weapon2D

@export var speed : float = 1000
@export var weapon_sprite : Sprite2D
@export var can_attack : bool = true
@export var attack_rate : float = 0.5
@export var sound_weapon : AudioStreamPlayer2D
@export var projectile : PackedScene
@export var projectile_point : Node2D
var guard_weapon : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_facing_direction()
	if Input.is_action_just_pressed('horizontal_attack'):
		pass
		
func attack() -> void:
	pass
	
func attack_alt() -> void:
	pass

func update_facing_direction() -> void:
	look_at(get_global_mouse_position())
	var relative_mouse_position : Vector2 = get_global_mouse_position() - global_position
	# Flip the Gun Sprite
	flip_sprite(relative_mouse_position.x)
	
func update_guard_direction() -> void:
	var weapon_position : Vector2 = global_position
	var relative_position : Vector2 = weapon_position - get_global_mouse_position()
	var x : int = 0
	var y  : int = 0
	if abs(relative_position.x) > 10:
		x = -100 if relative_position.x > 10 else 100
	else:
		x = 0
	if abs(relative_position.y) > 10:
		y = -100 if relative_position.y > 10 else 100
	else:
		y = 0

	var guard_position: Vector2 = weapon_position + Vector2(x,y)
		
	look_at(guard_position)
	flip_sprite(relative_position.x * -1)

		
func flip_sprite(relative_position_x: int) -> void:
		# Flip the Weapon Sprite
	if relative_position_x > 0:
		weapon_sprite.flip_v = false
	elif relative_position_x < 0:
		weapon_sprite.flip_v = true
