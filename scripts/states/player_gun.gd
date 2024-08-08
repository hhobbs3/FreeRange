extends StatePlayer
class_name PlayerGun

@export var jump_animation : String = "jump"
var bullet = preload('res://scenes/bullet.tscn')
@export var bullet_speed = 1000
func Enter():
	player.flap_count = 0
	player.sprite_gun.visible = true
	
func Exit():
	player.sprite_gun.visible = false
	
func Update(_delta: float):
	var mouse_position = player.get_global_mouse_position()
	player.sprite_gun.rotate(player.sprite_gun.get_angle_to(mouse_position))
	var gun_direction = get_viewport().get_mouse_position().x - player.position.x
	# update_facing_direction(mouse_position.x)
	if Input.is_action_pressed('horizontal_attack'):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = player.sprite_gun.position
		# bullet_instance.rotation_degrees = rotation_degrees
		# bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))

func Physics_Update(_delta: float):
	
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	
	if !player.is_on_floor():
		Transitioned.emit(self, 'Air')
		
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		player.velocity.y = player.jump_velocity / 4
		Transitioned.emit(self, "Air")
	
	if Input.is_action_just_pressed("gun"):
		Transitioned.emit(self, "Ground")
		
func jump():
	player.velocity.y = player.jump_velocity
	playback.travel(jump_animation)

func update_facing_direction(direction):
	# Flip the Gun Sprite
	if direction > 0:
		player.sprite_gun.flip_h = false
	elif direction < 0:
		player.sprite_gun.flip_h = true
