extends StatePlayer
class_name PlayerGround

@export var jump_animation : String = "jump"
@onready var sound_jump = $"../../SoundJump"
@onready var timer = $Timer
@onready var timer_jump_buffer = $TimerJumpBuffer

var jump_buffer : bool = false
@export var jump_buffer_time : float = 0.1

func Enter():
	player.extra_jumps_count = 0
	
func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	if player.current_health <= 0:
			Transitioned.emit(self, "Die")
	
	# Lost momentum
	if player.velocity.length() == 0:
		timer.start(1)

	# Dash
	if Input.is_action_just_pressed("dash") and player.can_dash:
		dash()
	# Slide
	if Input.is_action_just_pressed("slide"):
		slide()
	
	# Jump
	if !player.is_on_floor(): 
		# jump buffer
		
		timer_jump_buffer.start(jump_buffer_time)
		
	if Input.is_action_just_pressed("jump"):
		# jump
		jump()
	
	if Input.is_action_just_released('jump') and player.velocity.y < 0:
		# jump cutting
		player.velocity.y = player.jump_velocity / 4
		Transitioned.emit(self, "Air")
	
	if Input.is_action_just_pressed("gun"):
		Transitioned.emit(self, "Gun")
		
func jump()-> void:
	if randi_range(0, 10) > 8:
		sound_jump.play()
	player.velocity.y = player.jump_velocity
	playback.travel(jump_animation)
	
func dash():
	player.speed += player.SPEED_INCREMENT
	player.can_dash = false
	timer.start(2)
	playback.travel("dash")
	
func slide():
	playback.travel("slide")
	player.can_dash = true
	timer.stop() # cancle decelleration 

func _on_timer_timeout():
	player.speed = player.BASE_SPEED
	player.can_dash = true

func _on_timer_jump_buffer_timeout():
	if !player.is_on_floor():
		Transitioned.emit(self, 'Air')
	
