extends CharacterBody2D
class_name Player

signal health_changed

const SPEED = 130.0



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_gravity = gravity * 1.5


@onready var sprite_chicken : Sprite2D = $SpriteChicken
@onready var sprite_gun : Sprite2D = $WeaponsMarker/SpriteGun

@onready var player_collision_horizontal_attack = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack
@onready var player_sprite_attack_box = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack/PlayerSpriteAttackBox
@onready var state_machine : StateMachine = $StateMachine

@onready var hand_main = $HandMain
@onready var hand_off = $HandOff


@onready var hurt_timer = Timer
@export var max_health = 3
@onready var current_health: int = max_health

@export var knockback_power: int = 400

@export var jump_velocity : float = -400.0
var max_flaps: int = 10
var flap_velocity: float = jump_velocity / 2
var flap_count: int = 0

var is_hurt: bool = false
var is_attacking: bool = false

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
	if Input.is_action_just_pressed("hand_main"):
		player_collision_horizontal_attack.disabled = false
		player_sprite_attack_box.visible = true
	else:
		player_collision_horizontal_attack.disabled = true
		player_sprite_attack_box.visible = false

	
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

	emit_signal("facing_direction_changed", !sprite_chicken.flip_h)

	# Apply movement
	if direction.x && state_machine.check_if_can_move():
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func update_animation(direction):
	animation_tree.set('parameters/Move/blend_position', direction.x)

func update_facing_direction(direction):
	var mouse_pos = get_global_mouse_position()
	var relative_position = global_position - get_global_mouse_position()
	
	# Flip the Sprite
	if relative_position.x > 0: # alt direction.x
		sprite_chicken.flip_h = true
		hand_main.z_index  = 2
		hand_off.z_index = -1
		# sprite_gun.flip_h = false
		player_collision_horizontal_attack.position.x = 15
	elif relative_position.x < 0:
		sprite_chicken.flip_h = false
		hand_main.z_index  = -1
		hand_off.z_index = 2
		# sprite_gun.flip_h = true
		player_collision_horizontal_attack.position.x = -15
		
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
	sprite_chicken.play("hurt")
	# hurt_timer.start()
	# await hurt_timer.timeout
	sprite_chicken.play('reset')
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



