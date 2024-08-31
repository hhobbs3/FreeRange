extends StatePlayer
class_name PlayerAir
# CONTROLS
@export var c_dive : String = "shift"

@export var air_jump : String = "air_jump"
@export var landing_animation : String = "landing"

var wall_slide_gravity : float = gravity / 2
var is_wall_sliding : bool = false
var do_wall_jump : bool = false

var can_dive : bool = true

@onready var timer_wall_jump : Timer = $TimerWallJump
@onready var state_machine: StateMachine = $".."


func Enter() -> void:
	can_dive = true
	
func Exit() -> void:
	if playback:
		playback.travel(landing_animation)
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:	
	# GENERAL MOVEMENT
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.x && state_machine.check_if_can_move():
		player.velocity.x = direction.x * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
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
		wall_jump(direction.x)

	if direction and not do_wall_jump: player.velocity.x += direction.x * player.BASE_SPEED
	elif not do_wall_jump: player.velocity.x = move_toward(player.velocity.x, 0, player.BASE_SPEED)
	
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		# jump cutting
		player.velocity.y = player.jump_velocity / 4

	# DIVE
	if Input.is_action_just_pressed(c_dive):
		air_dive(direction.x)
		
	player.move_and_slide()
func jump() -> void:
	if player.velocity.y < 0: # maintain momentum
		player.velocity.y += player.jump_velocity
	else: # reset momentum
		player.velocity.y = player.jump_velocity
	playback.travel('jump')
	
func extra_jump() -> void:
	if player.extra_jumps_count < player.max_jumps:
		player.velocity.y = player.extra_jumps_velocity
		playback.travel(air_jump)
		player.extra_jumps_count += 1

func air_dive(horizontal_direction: float) -> void:
	if can_dive:
		player.velocity.x += player.dive_velocity * horizontal_direction * 10
		playback.travel("dive")
		can_dive = false

func wall_jump(horizontal_direction: float) -> void: 
	jump()
	player.velocity.x += -horizontal_direction * player.BASE_SPEED * 10
	do_wall_jump = true
	timer_wall_jump.start()

func _on_timer_wall_jump_timeout() -> void:
	do_wall_jump = false
