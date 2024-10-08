extends StatePlayer
class_name PlayerGun

@export var jump_animation : String = "jump"
var bullet = preload('res://scenes/weapons/bullet.tscn')
@export var bullet_speed = 1000
func Enter():
	player.flap_count = 0
	player.sprite_gun.visible = true
	
func Exit():
	player.sprite_gun.visible = false
	
func Update(_delta: float):
	update_facing_direction()
	
	if Input.is_action_just_pressed('horizontal_attack'):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = player.sprite_gun.position
		bullet_instance.rotation_degrees = player.sprite_gun.rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(player.sprite_gun.rotation))
		add_child(bullet_instance)
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
