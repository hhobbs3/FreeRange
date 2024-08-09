extends Node2D
var bullet = preload('res://scenes/weapons/bullet.tscn')
@export var bullet_speed = 1000
@onready var player : CharacterBody2D;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_facing_direction()
	if Input.is_action_just_pressed('horizontal_attack'):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = player.sprite_gun.position
		bullet_instance.rotation_degrees = player.sprite_gun.rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(player.sprite_gun.rotation))
		add_child(bullet_instance)
func update_facing_direction():
	var mouse_position = player.get_local_mouse_position()
	player.sprite_gun.look_at(mouse_position * Vector2(1, 10))
	# Flip the Gun Sprite
	if mouse_position.x > 0:
		player.sprite_gun.flip_h = false
		player.sprite_gun.look_at(mouse_position * Vector2(1, 10))
		# player.sprite_gun.rotate(player.sprite_gun.get_angle_to(mouse_position))
	elif mouse_position.x < 0:
		player.sprite_gun.flip_h = true
		player.sprite_gun.look_at(-mouse_position * Vector2(1, 10))
