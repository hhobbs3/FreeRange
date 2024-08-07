extends StatePlayer
class_name PlayerGun

@export var jump_animation : String = "jump"

func Enter():
	player.flap_count = 0
	player.sprite_gun.visible = true
	
func Exit():
	player.sprite_gun.visible = false
	
func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	#var mouse_position = get_viewport().get_mouse_position()
	#var direction = (mouse_position - player.position).normalized()
	#var new_angle =  PI + atan2(direction.y, direction.x) 
	# player.rotation  = new_angle
	
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

