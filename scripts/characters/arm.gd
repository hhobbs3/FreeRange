extends Node2D
class_name Arm2D

var gun = preload("res://scenes/weapons/gun.tscn")
var sword = preload("res://scenes/weapons/sword.tscn")

@export var button : String
@export var weapon_type : String
@export var parent_body : CharacterBody2D
@onready var shoulder_point : Node2D = $ShoulderPoint
@onready var hand_point : Node2D = $ShoulderPoint/ArmSprite/HandPoint
@onready var hand_point_sword : Node2D = $ShoulderPoint/ArmSprite/HandPointSword
@onready var hand_point_gun : Node2D = $ShoulderPoint/ArmSprite/HandPointGun
@onready var arm_sprite : Sprite2D = $ShoulderPoint/ArmSprite
@onready var weapon : Weapon2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var guard_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hand_point_position = Vector2.ZERO
	match weapon_type:
		'sword':
			weapon = sword.instantiate()
			arm_sprite.frame = 8
			hand_point.position = hand_point_sword.position
			hand_point.rotation = hand_point_sword.rotation
		'gun':
			weapon = gun.instantiate()
			arm_sprite.frame = 1
			hand_point.position = hand_point_gun.position
			hand_point.rotation = hand_point_gun.rotation
	hand_point.add_child(weapon)
	
	match button:
		'hand_main':
			z_index = parent_body.z_index + 1
		'hand_off':
			z_index = parent_body.z_index - 1
			shoulder_point.position += Vector2(2,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	hand_attack(weapon, button)

func hand_attack(weapon: Weapon2D, button_pressed: String) -> void:
	if weapon:
		if weapon.guard_weapon:
			update_guard_direction()
		else:
			update_facing_direction()
		if Input.is_action_just_pressed(button_pressed) and weapon.can_attack:
			if weapon.guard_weapon:
				animate_guard_position() 
			weapon.attack()

func update_facing_direction() -> void:
	var mouse_pos = get_global_mouse_position()
	var relative_mouse_position = mouse_pos - global_position
	# Flip the sprite
	flip_sprite(relative_mouse_position.x)

	shoulder_point.look_at(mouse_pos)
	
func update_guard_direction() -> void:
	var weapon_position = global_position
	var relative_position = weapon_position - get_global_mouse_position()
	var x = 0
	var y = 0
	# breaks up look location into 8 possible positions (clock like pointing)
	if abs(relative_position.x) > 10:
		x = -100 if relative_position.x > 10 else 100
	else:
		x = 0
	if abs(relative_position.y) > 10:
		y = -100 if relative_position.y > 10 else 100
	else:
		y = 0

	guard_position = Vector2(x,y)
	var relative_guard_position = weapon_position + guard_position
		
	shoulder_point.look_at(relative_guard_position)
	flip_sprite(relative_position.x * -1)

		
func flip_sprite(relative_position_x: int) -> void:
	# Flip the arm sprite
	if relative_position_x > 0:
		arm_sprite.flip_v = false
		weapon.scale.y = 1
	elif relative_position_x < 0:
		arm_sprite.flip_v = true
		weapon.scale.y = -1

	# keep arms on correct side of body
	match button:
		'hand_main':
			z_index = parent_body.z_index + 10 * (-1 * int(relative_position_x < 0))
		'hand_off':
			z_index = parent_body.z_index + 10 * (-1 * int(relative_position_x > 0))
	
func animate_guard_position() -> void:
	var animation = 'stab'
	print(guard_position)
	if abs(guard_position.y) > 0:
		animation = 'slice'
	animation_player.play(animation)
