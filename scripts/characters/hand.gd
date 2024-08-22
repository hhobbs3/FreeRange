extends Node2D

var gun = preload("res://scenes/weapons/gun.tscn")
var sword = preload("res://scenes/weapons/sword.tscn")

@export var weapon_type : String
@onready var weapon : Weapon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hand_flip():
	pass
		
