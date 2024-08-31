extends CharacterBody2D
class_name Player

signal health_changed

# DASH
var can_dash : bool = true
const BASE_SPEED : float = 300.0
const MAX_SPEED : float = 500.0
const ACCELERATION : float = 50.0
const DECELERATION : float = 50.0
const SPEED_INCREMENT : float = 100.0
var speed : float = BASE_SPEED


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_gravity = gravity * 1.5

# SPRITE
@export var sprite_player : Sprite2D

# collision
@onready var collision_shape : CollisionShape2D = $CollisionShape
@onready var collision_shape_hitbox : CollisionShape2D = $Hitbox/CollisionShapeHitbox


@onready var player_sprite_attack_box = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack/PlayerSpriteAttackBox
@onready var state_machine : StateMachine = $StateMachine

# APENDAGES
@onready var hand_main = $HandMain
@onready var hand_off = $HandOff


@export var knockback_power: int = 400



# JUMP
@export var jump_velocity : float = -400.0
var max_jumps: int = 10
var extra_jumps_velocity: float = jump_velocity / 2
var extra_jumps_count: int = 0
var on_ground : bool = true
var dive_velocity : float = 400
var wall_jump_velocity : float = 10000

# HEALTH
@onready var hurt_timer = Timer
@export var max_health = 3
@onready var current_health: int = max_health
var is_hurt: bool = false

# ATTACK
@onready var player_collision_horizontal_attack = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack
var is_attacking: bool = false


signal facing_direction_changed(facing_right : bool)

# animation player stuff
@onready var animation_tree : AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true

func _physics_process(delta):

	# Get the input direction
	var direction = Input.get_vector("move_left", "move_right", "look_up", "look_down")
	# Play animations
	update_animation(direction)
	# Flip the Sprite
	update_facing_direction(direction)

	emit_signal("facing_direction_changed", !sprite_player.flip_h)

func update_animation(direction):
	animation_tree.set('parameters/Move/blend_position', direction.x)

func update_facing_direction(direction):
	var mouse_pos = get_global_mouse_position()
	var relative_position = global_position - get_global_mouse_position()
	print(relative_position)
	# Flip the Sprite
	if relative_position.x > 0: # alt direction.x
		print('x>0')
		sprite_player.flip_h = true
		if hand_main:
			hand_main.z_index  = 2
			hand_off.z_index = -1

		player_collision_horizontal_attack.position.x = 15
	elif relative_position.x < 0:
		print('x<0')
		sprite_player.flip_h = false
		if hand_main:
			hand_main.z_index  = -1
			hand_off.z_index = 2
		
		player_collision_horizontal_attack.position.x = -15

func hurtByEnemy(area):
	current_health -= 10
	if current_health < 0:
		current_health = max_health
		
	is_hurt = true
	health_changed.emit()
	
	knockback(area.get_parent().velocity)
	sprite_player.play("hurt")
	sprite_player.play('reset')
	is_hurt = false
	
func knockback(enemy_velocity: Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group('Hit'):
		body.take_damage()
	else:
		pass
		
func _on_area_2d_chicken_hitbox_area_entered(area):
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


func update_collision_shape(r: float, h: float, r_deg: float, pos_y: int):
	# rotation, height, rotation degrees
	# standing = 7, 40, 0, -20
	# crouching = 9, 20, 0, -10
	# prone = 7, 38, 90, -7
	collision_shape.shape.radius = r
	collision_shape_hitbox.shape.radius = r
	collision_shape.shape.height = h
	collision_shape_hitbox.shape.height = h
	collision_shape.rotation_degrees = r_deg
	collision_shape_hitbox.rotation_degrees = r_deg
	collision_shape.position = Vector2(0, pos_y)
	collision_shape_hitbox.position = Vector2(0, pos_y)
	pass
