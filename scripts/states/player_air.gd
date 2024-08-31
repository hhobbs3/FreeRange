extends StatePlayer
class_name PlayerAir
@export var air_jump : String = "air_jump"
@export var dive : String = "slide"
@export var landing_animation : String = "landing"

var wall_slide_gravity : float = gravity / 2
var is_wall_sliding : bool = false
var do_wall_jump : bool = false

@onready var timer_wall_jump : Timer = $TimerWallJump



func Enter() -> void:
	pass
	
func Exit() -> void:
	if playback:
		playback.travel(landing_animation)
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:
	var direction : float = Input.get_axis('move_left', 'move_right')
	
	# DOWNWARD VELOCITY
	if player.is_on_wall_only() and (Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right')):
		player.velocity.y += wall_slide_gravity * delta
	else:
		player.velocity.y += gravity * delta	
		
	# DIE
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
			
	# GROUND	
	if player.is_on_floor():
		player.on_ground = true
		Transitioned.emit(self, 'Ground')
		
	# WALL JUMP
	if Input.is_action_just_pressed("jump") and player.is_on_wall_only():
		jump()
		player.velocity.x = -direction * player.BASE_SPEED
		do_wall_jump = true
		timer_wall_jump.start()

	if direction and not do_wall_jump: player.velocity.x = direction * player.BASE_SPEED
	elif not do_wall_jump: player.velocity.x = move_toward(player.velocity.x, 0, player.BASE_SPEED)
	
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		# jump cutting
		player.velocity.y = player.jump_velocity / 4

	# DIVE
	if Input.is_action_just_pressed(dive):
		air_dive(direction)
		
func jump()-> void:
	player.velocity.y = player.jump_velocity
	playback.travel('jump')
	
func extra_jump() -> void:
	if player.extra_jumps_count < player.max_jumps:
		player.velocity.y = player.extra_jumps_velocity
		playback.travel(air_jump)
		player.extra_jumps_count += 1

func air_dive(direction: float) -> void:
	# it animates but doesn't actually affect velocity
	player.velocity.x += player.dive_velocity * direction * 10000
	playback.travel("dive")


func _on_timer_wall_jump_timeout() -> void:
	do_wall_jump = false
