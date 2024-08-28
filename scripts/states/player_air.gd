extends StatePlayer
class_name PlayerAir
@export var air_jump : String = "air_jump"
@export var landing_animation : String = "landing"
func Enter() -> void:
	pass
	
func Exit() -> void:
	if playback:
		playback.travel(landing_animation)
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(_delta: float) -> void:
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		player.velocity.y = player.jump_velocity / 4
	if player.is_on_floor():
		Transitioned.emit(self, 'Ground')
	if Input.is_action_just_pressed("jump"):
		extra_jump()
		
func extra_jump() -> void:
	if player.extra_jumps_count < player.max_jumps:
		player.velocity.y = player.extra_jumps_velocity
		playback.travel(air_jump)
		player.extra_jumps_count += 1
