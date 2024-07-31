extends CharacterBody2D
class_name Player

signal health_changed

const SPEED = 130.0
const JUMP_VELOCITY = -400.0





# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_gravity = gravity * 1.5
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_collision_horizontal_attack = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack
@onready var player_sprite_attack_box = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack/PlayerSpriteAttackBox


@onready var hurt_timer = Timer
@export var max_health = 3
@onready var current_health: int = max_health

@export var knockback_power: int = 400

var is_hurt: bool = false
var is_attacking: bool = false

var max_flaps: int = 10
var flap_force: float = JUMP_VELOCITY / 2
var flap_count: int = 0
var head = 'idle'
var has_collided_with_player = true;

signal facing_direction_changed(facing_right : bool)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle attack
	if Input.is_action_just_pressed("horizontal_attack"):
		print('horizontal_attack player')
		player_collision_horizontal_attack.disabled = false
		player_sprite_attack_box.visible = true
		# attack animation
	else:
		player_collision_horizontal_attack.disabled = true
		player_sprite_attack_box.visible = false

	# Handle jump / flap
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			flap_count = 0
			velocity.y = JUMP_VELOCITY
		elif flap_count < max_flaps:
			velocity.y = flap_force
			flap_count += 1
	
	if Input.is_action_just_released('jump') and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	
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
		player_collision_horizontal_attack.position.x = 15
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		player_collision_horizontal_attack.position.x = -15

	emit_signal("facing_direction_changed", !animated_sprite_2d.flip_h)
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
	print('in player body entered ' + str(body))
	if body.is_in_group('Hit'):
		body.take_damage()
		print('_on_area_2d_body_entered player area2d')
	else:
		pass
		
func _on_area_2d_chicken_hitbox_area_entered(area):
	print('area')
	if area.is_in_group('enemy_attack'):
		take_damage(1)
		
func take_damage(damage):
	current_health -= damage
	velocity.y -= 100
	if current_health <= 0:
		print('health = ' + str(current_health))
		print('switch to die')
		print('die')
		# Transitioned.emit(self, "Die")



