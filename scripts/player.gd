extends CharacterBody2D
class_name Player

signal health_changed

const SPEED = 130.0
const JUMP_VELOCITY = -400.0





# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_gravity = gravity * 1.5
@onready var sprite : Sprite2D = $Sprite2D
@onready var player_collision_horizontal_attack = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack
@onready var player_sprite_attack_box = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack/PlayerSpriteAttackBox
@onready var state_machine : StateMachine = $StateMachine


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

# animation player stuff
@onready var animation_tree : AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true

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

	# Get the input direction
	var direction = Input.get_vector("move_left", "move_right", "look_up", "look_down")
	# Play animations
	update_animation(direction)
	# Flip the Sprite
	update_facing_direction(direction)

	emit_signal("facing_direction_changed", !sprite.flip_h)
	# Play animations
	
	'''
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
	'''
		
	# Apply movement
	if direction.x && state_machine.check_if_can_move():
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func update_animation(direction):
	animation_tree.set('parameters/Move/blend_position', direction.x)

func update_facing_direction(direction):
	# Flip the Sprite
	if direction.x > 0:
		sprite.flip_h = false
		player_collision_horizontal_attack.position.x = 15
	elif direction.x < 0:
		sprite.flip_h = true
		player_collision_horizontal_attack.position.x = -15

func jump():
	velocity.y = JUMP_VELOCITY
	# animation_locked = true
	
func double_jump():
	velocity.y = flap_force
	# animation_locked = true
	
func land():
	pass
	# animation_locked = true
	
# func _on_animated_sprite_2d_animation_finished():

func hurtByEnemy(area):
	current_health -= 10
	if current_health < 0:
		current_health = max_health
		
	is_hurt = true
	health_changed.emit()
	
	knockback(area.get_parent().velocity)
	sprite.play("hurt")
	# hurt_timer.start()
	# await hurt_timer.timeout
	sprite.play('reset')
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



