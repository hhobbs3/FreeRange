extends Node
class_name State

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var can_move : bool = true
signal Transitioned

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
