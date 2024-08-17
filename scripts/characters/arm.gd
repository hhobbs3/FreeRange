extends Node2D
class_name Arm2D

# @export var arm_sprite : Sprite2D
# @export var weapon : Weapon2D
@export var button : String
@onready var shoulder_point = $ShoulderPoint
@onready var arm_sprite = $ShoulderPoint/ArmSprite
@onready var weapons = $ShoulderPoint/ArmSprite/Weapons
@onready var weapon : Weapon2D = $ShoulderPoint/ArmSprite/Gun


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	shoulder_point.look_at(mouse_pos)
	var relative_mouse_position = mouse_pos - global_position
	# Flip the Gun Sprite
	flip_sprite(relative_mouse_position.x)
	
func update_guard_direction():
	var weapon_position = global_position
	var relative_position = weapon_position - get_global_mouse_position()
	var x = 0
	var y = 0
	if abs(relative_position.x) > 10:
		x = -100 if relative_position.x > 10 else 100
	else:
		x = 0
	if abs(relative_position.y) > 10:
		y = -100 if relative_position.y > 10 else 100
	else:
		y = 0

	var guard_position = weapon_position + Vector2(x,y)
		
	shoulder_point.look_at(guard_position)
	# arm_sprite.look_at(guard_position)
	# weapon.look_at(guard_position)
	flip_sprite(relative_position.x * -1)

		
func flip_sprite(relative_position_x: int):
		# Flip the Weapon Sprite

	if relative_position_x > 0:
		arm_sprite.flip_v = false
		weapon.weapon_sprite.flip_v = false
		# weapon.weapon_sprite.position.x = 0
	elif relative_position_x < 0:
		arm_sprite.flip_v = true
		weapon.weapon_sprite.flip_v = true
		print(weapon.weapon_sprite.position)
		# weapon.weapon_sprite.position.x = 0
