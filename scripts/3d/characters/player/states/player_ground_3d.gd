extends StateEgo
class_name PlayerGround3D

@export var jump_animation : String = "jump"
@onready var sound_jump: AudioStreamPlayer3D = $SoundJump
@onready var timer = $Timer
@onready var timer_jump_buffer = $TimerJumpBuffer
@onready var state_machine = $".."

var is_sliding : bool = false

var jump_buffer : bool = false
@export var jump_buffer_time : float = 0.1

# CONTROLS
@export var c_dash : String = "shift"

func Enter() -> void:
	ego.extra_jumps_count = 0
	is_sliding = false
	
func Update(_delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:
	'''
	# DIE
	if ego.current_health <= 0:
		pass #	Transitioned.emit(self, "Die")
	
	# LOST MOMENTUM
	if ego.velocity.length() == 0:
		timer.start(1)
		
	# STAND
	if Input.is_action_just_pressed('move_up'):
		stand()
		
	# JUMP
	if !ego.is_on_floor() and ego.on_ground == true:
		# jump buffer
		ego.on_ground = false
		timer_jump_buffer.start(jump_buffer_time)
		
	if Input.is_action_just_pressed("jump"):
		# jump
		jump()
	
	if Input.is_action_just_released('jump') and ego.velocity.y < 0:
		# jump cutting
		ego.velocity.y = ego.jump_velocity / 4
		pass #	Transitioned.emit(self, "Air")# 
	
	if is_sliding:
		if abs(ego.velocity.x) < 10:
			is_sliding = false
		ego.velocity.x += -ego.velocity.x / 50
	else:
		print('not sliding')
	
		# APPLY MOVEMENT
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if direction.x && state_machine.check_if_can_move():
			ego.velocity.x = direction.x * ego.speed
		else:
			ego.velocity.x = move_toward(ego.velocity.x, 0, ego.speed)
		# Dash
		if Input.is_action_just_pressed(c_dash) and ego.can_dash:
			dash()
		
		if Input.is_action_just_pressed('move_down'):
			if abs(ego.velocity.x) > 100:
				# Slide
				slide()
			else:
				# Crouch
				crouch()

	# APPLY MOVEMENT
	ego.move_and_slide()
	'''
		
func jump()-> void:
	if randi_range(0, 10) > 0:
		sound_jump.play()
	# ego.velocity.y = ego.jump_velocity
	# playback.travel(jump_animation)
	
func dash() -> void:
	ego.speed += ego.SPEED_INCREMENT
	ego.can_dash = false
	timer.start(2)
	# playback.travel("dash")
	
func slide() -> void:
	# playback.travel("slide")
	ego.can_dash = true
	timer.stop() # cancle decelleration 
	is_sliding = true
	
func crouch() -> void:
	# playback.travel("crouch")
	pass #	Transitioned.emit(self, "Crouch")

func stand() -> void:
	# playback.travel("idle")
	is_sliding = false

func _on_timer_timeout() -> void:
	ego.speed = ego.BASE_SPEED
	ego.can_dash = true

func _on_timer_jump_buffer_timeout() -> void:
	if !ego.is_on_floor():
		pass #	Transitioned.emit(self, 'Air')
