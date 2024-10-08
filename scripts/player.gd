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
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_gravity : float = gravity * 1.5

# SPRITE
@onready var animation_player_custom: AnimationPlayer = $AnimationPlayerCustom
@onready var sprite_torso: Sprite2D = $Sprites/PointTorso/SpriteTorso
@onready var point_arm_far: Node2D = $Sprites/PointArmFar
@onready var point_head: Node2D = $Sprites/PointHead
@onready var point_arm_near: Node2D = $Sprites/PointArmNear
@onready var point_legs: Node2D = $Sprites/PointLegs
@onready var sprite_heads: Sprite2D = $Sprites/PointHead/SpriteHeads

const sprite_head_pos: Array[int] = [2, -100]

@onready var sprites: Node2D = $Sprites


# collision
@onready var collision_shape : CollisionShape2D = $CollisionShape
@onready var collision_shape_hitbox : CollisionShape2D = $Hitbox/CollisionShapeHitbox


@onready var player_sprite_attack_box : Sprite2D = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack/PlayerSpriteAttackBox
@onready var state_machine : StateMachine = $StateMachine

# APENDAGES
@onready var hand_main : Arm2D = $HandMain
@onready var hand_off : Arm2D = $HandOff


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
@onready var hurt_timer: Timer = $Timer
@export var max_health : int = 3
@onready var current_health: int = max_health
var is_hurt: bool = false

# ATTACK
@onready var player_collision_horizontal_attack : CollisionShape2D = $PlayerHorizontalAttack/PlayerCollisionHorizontalAttack
var is_attacking: bool = false


signal facing_direction_changed(facing_right : bool)

# animation player stuff
@onready var animation_tree : AnimationTree = $AnimationTree

func _ready() -> void:
	animation_tree.active = true
	

func _physics_process(_delta : float) -> void:

	# Get the input direction
	var direction : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Play animations
	update_animation(direction)
	# Flip the Sprite
	update_facing_direction(direction)

	# emit_signal("facing_direction_changed", !sprite_player.flip_h)

func update_animation(direction : Vector2) -> void:
	animation_tree.set('parameters/Move/blend_position', direction.x)

func update_facing_direction(_direction : Vector2) -> void:
	var relative_position : Vector2 = global_position - get_global_mouse_position()
	print(relative_position)
	# Flip the Sprite
	if relative_position.x > 0: # alt direction.x
		print('x>0')
		sprites.scale.x = -1
		'''
		sprite_torso.flip_h = true
		# sprite_heads.flip_h = true
		point_head.scale.x = -1
		point_arm_far.scale.x = -1
		point_arm_near.scale.x = -1
		point_legs.scale.x = -1
		sprite_heads.position.x = sprite_head_pos[1]
		'''
		if hand_main:
			hand_main.z_index  = 2
			hand_off.z_index = -1

		player_collision_horizontal_attack.position.x = 15
	elif relative_position.x < 0:
		print('x<0')
		sprites.scale.x = 1
		'''
		sprite_torso.flip_h = false
		# sprite_heads.flip_h = false
		point_head.scale.x = 1
		point_arm_far.scale.x = 1
		point_arm_near.scale.x = 1
		point_legs.scale.x = 1
		sprite_heads.position.x = sprite_head_pos[0]
		'''
		if hand_main:
			hand_main.z_index  = -1
			hand_off.z_index = 2
		
		player_collision_horizontal_attack.position.x = -15
	
# don't remember if needed...
func hurtByEnemy(area) -> void:
	current_health -= 10
	if current_health < 0:
		current_health = max_health
		
	is_hurt = true
	health_changed.emit()
	
	knockback(area.get_parent().velocity)
	# sprite_player.play("hurt")
	# sprite_player.play('reset')
	is_hurt = false
	
func knockback(enemy_velocity: Vector2) -> void:
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group('Hit'):
		body.take_damage()
	else:
		pass
		
func _on_area_2d_chicken_hitbox_area_entered(area) -> void:
	if area.is_in_group('enemy_attack'):
		take_damage(1)
		
func take_damage(damage) -> void:
	current_health -= damage
	velocity.y -= 100
	if current_health <= 0:
		print('health = ' + str(current_health))
		print('switch to die')
		print('die')
		# Transitioned.emit(self, "Die")


func update_collision_shape(r: float, h: float, r_deg: float, pos_y: int) -> void:
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
