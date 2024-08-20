extends Node2D
class_name Arm2D

var gun = preload("res://scenes/weapons/gun.tscn")
var sword = preload("res://scenes/weapons/sword.tscn")

@export var button : String
@export var weapon_type : String
@export var parent_body : CharacterBody2D
@onready var shoulder_point = $ShoulderPoint
@onready var hand_point_sword = $ShoulderPoint/ArmSprite/HandPointSword
@onready var hand_point_gun = $ShoulderPoint/ArmSprite/HandPointGun
@onready var arm_sprite = $ShoulderPoint/ArmSprite
@onready var weapons = $ShoulderPoint/ArmSprite/Weapons
@onready var weapon : Weapon2D



# Called when the node enters the scene tree for the first time.
func _ready():
	var hand_point_position = Vector2.ZERO
	match weapon_type:
		'sword':
			weapon = sword.instantiate()
			arm_sprite.frame = 18
			hand_point_position = hand_point_sword.position
		'gun':
			weapon = gun.instantiate()
			arm_sprite.frame = 17
			hand_point_position = hand_point_gun.position
	weapon.position = hand_point_position
	get_child(0).get_child(0).add_child(weapon)
	
	match button:
		'hand_main':
			z_index = parent_body.z_index + 1
		'hand_off':
			z_index = parent_body.z_index - 1
			shoulder_point.position += Vector2(2,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print('weapon.position' + str(weapon.position))
	hand_attack(weapon, button)

func hand_attack(weapon: Weapon2D, button_pressed: String):
	if weapon:
		if weapon.guard_weapon:
			update_guard_direction()
		else:
			update_facing_direction()
		if Input.is_action_just_pressed(button_pressed) and weapon.can_attack:
			weapon.attack()

func update_facing_direction():
	var mouse_pos = get_global_mouse_position()
	var relative_mouse_position = mouse_pos - global_position
	# Flip the sprite
	flip_sprite(relative_mouse_position.x)

	shoulder_point.look_at(mouse_pos)
	
func update_guard_direction():
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

	var guard_position = weapon_position + Vector2(x,y)
		
	flip_sprite(relative_position.x * -1)
	shoulder_point.look_at(guard_position)
	flip_sprite(relative_position.x * -1)

		
func flip_sprite(relative_position_x: int):
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
	
