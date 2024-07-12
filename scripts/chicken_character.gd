extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

var max_flaps: int = 10
var flap_force: float = 100.0
var flap_count: int = 0
var head = 'idle'
var has_collided_with_player = false;
var past_direction = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if has_collided_with_player:
		# Handle jump / flap
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				flap_count = 0
				velocity.y = JUMP_VELOCITY
			elif flap_count < max_flaps:
				velocity.y = -flap_force
				flap_count += 1
				
	# Handle head state
		if Input.is_action_just_pressed("look_up"):
			head = 'look_up'
		if Input.is_action_just_pressed("look_down"):
			head = 'look_down'
		if Input.is_action_just_released('look_up') or Input.is_action_just_released('look_down'):
			head = 'idle'

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			if head == "look_up":
				animated_sprite_2d.play('look_up')
			elif head == "look_down":
				animated_sprite_2d.play("look_down")
			else:
				animated_sprite_2d.play('idle')
		else:
			animated_sprite_2d.play("run")
	elif flap_count == 0:
		animated_sprite_2d.play("jump")
	else:
		animated_sprite_2d.play("flap")
	
		
	if has_collided_with_player:
		# Apply movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		direction = (randi() % 3) - 1 + past_direction
		if direction:
			velocity.x = direction * SPEED / 3
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED / 3)
		past_direction = direction % 3

	move_and_slide()
