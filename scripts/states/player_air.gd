extends StatePlayer
class_name PlayerAir
@export var air_jump : String = "air_jump"
@export var dive : String = "slide"
@export var landing_animation : String = "landing"

func Enter() -> void:
	pass
	
func Exit() -> void:
	if playback:
		playback.travel(landing_animation)
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:
	player.velocity.y += gravity * delta
	# DIE
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	# GROUND	
	if player.is_on_floor():
		player.on_ground = true
		Transitioned.emit(self, 'Ground')
	# AIR JUMP
	if Input.is_action_just_pressed("jump"):
		if player.is_on_wall() and Input.is_action_pressed("move_right"):
			jump()
			player.velocity.x += -player.wall_jump_velocity
		if player.is_on_wall() and Input.is_action_pressed("move_left"):
			jump()
			player.velocity.x += player.wall_jump_velocity
		#else:
			# extra_jump()
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		# jump cutting
		player.velocity.y = player.jump_velocity / 4
	# DIVE
	if Input.is_action_just_pressed(dive):
		air_dive()
		
func jump()-> void:
	player.velocity.y = player.jump_velocity
	playback.travel('jump')
	
func extra_jump() -> void:
	if player.extra_jumps_count < player.max_jumps:
		player.velocity.y = player.extra_jumps_velocity
		playback.travel(air_jump)
		player.extra_jumps_count += 1

func air_dive() -> void:
	# it animates but doesn't actually affect velocity
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = player.dive_velocity * direction * 10000

	playback.travel("dive")
