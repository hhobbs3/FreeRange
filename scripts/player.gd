extends CharacterBody2D
class_name Player

signal health_changed

const SPEED = 130.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var collision_horizontal_attack = $Area2D/CollisionShape2DHorizontalAttack


@onready var hurt_timer = Timer
@export var max_health = 3
@onready var current_health: int = max_health

@export var knockback_power: int = 500

var is_hurt: bool = false
var is_attacking: bool = false

var max_flaps: int = 10
var flap_force: float = 100.0
var flap_count: int = 0
var head = 'idle'
var has_collided_with_player = true;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle attack
	if Input.is_action_just_pressed("horizontal_attack"):
		print('horizontal_attack player')
		collision_horizontal_attack.disabled = false
		# attack animation
	else:
		collision_horizontal_attack.disabled = true

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
	
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func hurtByEnemy(area):
	current_health -= 10
	if current_health < 0:
		current_health = max_health
		
	is_hurt = true
	health_changed.emit()
	
	knockback(area.get_parent().velocity)
	animated_sprite_2d.play("hurt")
	# hurt_timer.start()
	# await hurt_timer.timeout
	animated_sprite_2d.play('reset')
	is_hurt = false
	
func knockback(enemy_velocity: Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()


func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group('Hit'):
		body.take_damage()
		print('_on_area_2d_body_entered player area2d')
	else:
		pass
