extends StatePlayer
class_name PlayerGround

@export var jump_animation : String = "jump"
@onready var sound_jump = $"../../SoundJump"
@onready var timer = $Timer
@onready var timer_jump_buffer = $TimerJumpBuffer
@onready var state_machine = $".."

var is_sliding : bool = false

var jump_buffer : bool = false
@export var jump_buffer_time : float = 0.1

func Enter() -> void:
	player.extra_jumps_count = 0
	is_sliding = false
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:
	# DIE
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	
	# LOST MOMENTUM
	if player.velocity.length() == 0:
		timer.start(1)
		
	#JUMP
	if !player.is_on_floor() and player.on_ground == true:
		# jump buffer
		player.on_ground = false
		timer_jump_buffer.start(jump_buffer_time)
		
	if Input.is_action_just_pressed("jump"):
		# jump
		jump()
	
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		# jump cutting
		player.velocity.y = player.jump_velocity / 4
		Transitioned.emit(self, "Air")# 
	
	if is_sliding:
		if abs(player.velocity.x) < 10:
			is_sliding = false
		player.velocity.x += -player.velocity.x / 50
	else:
		print('not sliding')
	
		# APPLY MOVEMENT
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if direction.x && state_machine.check_if_can_move():
			player.velocity.x = direction.x * player.speed
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
		# Dash
		if Input.is_action_just_pressed("dash") and player.can_dash:
			dash()
		# Slide
		if Input.is_action_just_pressed("slide"):
			slide()
		if abs(player.velocity.x) > 100 and Input.is_action_just_pressed('move_down'):
			slide()
			
	# APPLY MOVEMENT
	player.move_and_slide()
		
func jump()-> void:
	if randi_range(0, 10) > 8:
		sound_jump.play()
	player.velocity.y = player.jump_velocity
	playback.travel(jump_animation)
	
func dash() -> void:
	player.speed += player.SPEED_INCREMENT
	player.can_dash = false
	timer.start(2)
	playback.travel("dash")
	
func slide() -> void:
	playback.travel("slide")
	player.can_dash = true
	timer.stop() # cancle decelleration 
	is_sliding = true

func _on_timer_timeout() -> void:
	player.speed = player.BASE_SPEED
	player.can_dash = true

func _on_timer_jump_buffer_timeout() -> void:
	if !player.is_on_floor():
		Transitioned.emit(self, 'Air')
