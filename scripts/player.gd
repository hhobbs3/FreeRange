extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

var max_flaps: int = 10
var flap_force: float = 100.0
var flap_count: int = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			flap_count = 0
			velocity.y = JUMP_VELOCITY
		elif flap_count < max_flaps:
			velocity.y = -flap_force
			flap_count += 1

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
			animated_sprite_2d.play('idle')
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
