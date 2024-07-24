extends Node
class_name State

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal Transitioned

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
