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
		fire()
		
func update_facing_direction():
	look_at(get_global_mouse_position())
	var relative_mouse_position = get_global_mouse_position() - global_position
	# Flip the Gun Sprite
	if relative_mouse_position.x > 0:
		gun_sprite_2d.flip_v = false
	elif relative_mouse_position.x < 0:
		gun_sprite_2d.flip_v = true

func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = position_offset() 
	bullet_instance.apply_impulse((Vector2(bullet_speed,0)).rotated(rotation))
	add_child(bullet_instance)

func position_offset():
	var offset = position + Vector2(20,0) #  + Vector2(20,0).rotated(rotation)
	return offset
