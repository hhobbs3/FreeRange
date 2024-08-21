extends Node2D

var gun = preload("res://scenes/weapons/gun.tscn")
var sword = preload("res://scenes/weapons/sword.tscn")

@export var weapon_type : String
@onready var weapon : Weapon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	'''var hand_point_position = Vector2.ZERO
	match weapon_type:
		'sword':
			weapon = sword.instantiate()
			hand_point_position = Vector2(26,0)
		'gun':
			weapon = gun.instantiate()
			hand_point_position = Vector2(30,0)
	add_child(weapon)'''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
