extends StatePlayer
class_name PlayerGround

@export var jump_animation : String = "jump"

func Enter():
	player.flap_count = 0
	
func Update(_delta: float):
	pass

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
		
func jump():
	player.velocity.y = player.jump_velocity
	playback.travel(jump_animation)

