extends Node2D
var bullet = preload('res://scenes/weapons/bullet.tscn')
@export var bullet_speed = 1000
@onready var gun_sprite_2d = $GunSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_facing_direction()
	if Input.is_action_just_pressed('horizontal_attack'):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = gun_sprite_2d.position
		bullet_instance.rotation_degrees = gun_sprite_2d.rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(gun_sprite_2d.rotation))
		add_child(bullet_instance)
func update_facing_direction():
	var mouse_position = gun_sprite_2d.get_global_mouse_position()

	# Flip the Gun Sprite
	if mouse_position.x > 0:
		gun_sprite_2d.flip_h = false
		gun_sprite_2d.look_at(mouse_position)
	elif mouse_position.x < 0:
		gun_sprite_2d.flip_h = true
		gun_sprite_2d.look_at(-mouse_position)
