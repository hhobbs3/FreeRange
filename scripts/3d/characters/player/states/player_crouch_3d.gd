extends StatePlayer
class_name PlayerCrouch

@export var jump_animation : String = "jump"
@onready var sound_jump = $"../../SoundJump"
@onready var timer = $Timer
@onready var timer_jump_buffer = $TimerJumpBuffer
@onready var state_machine = $".."

var is_sliding : bool = false

var jump_buffer : bool = false
@export var jump_buffer_time : float = 0.1

func Enter() -> void:
	pass
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:
	# DIE
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	
	# LOST MOMENTUM
	if player.velocity.length() == 0:
		timer.start(1)
		
	# STAND
	if Input.is_action_just_pressed('move_up'):
		stand()
		
		
	# JUMP
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
		Transitioned.emit(self, "Air")
	
	# APPLY MOVEMENT
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.x && state_machine.check_if_can_move():
		player.velocity.x = direction.x * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	# Dash
	if Input.is_action_just_pressed("dash") and player.can_dash:
		hop()
		
	if Input.is_action_just_pressed('move_down'):
		# Transitioned.emit(self, "Prone")# 
		pass
			
	# APPLY MOVEMENT
	player.move_and_slide()
		
func stand() -> void:
	playback.travel("idle")
	Transitioned.emit(self, "Ground")
		
func jump()-> void:
	player.velocity.y = player.jump_velocity / 2
	playback.travel(jump_animation)
	Transitioned.emit(self, 'Air')
	
func hop() -> void:
	player.speed += player.SPEED_INCREMENT / 2
	player.can_dash = false
	timer.start(2)
	playback.travel("hop")

func _on_timer_timeout() -> void:
	player.speed = player.BASE_SPEED
	player.can_dash = true

func _on_timer_jump_buffer_timeout() -> void:
	if !player.is_on_floor():
		Transitioned.emit(self, 'Air')
