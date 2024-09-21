extends Node
class_name State

var gravity : Variant = ProjectSettings.get_setting("physics/2d/default_gravity")
var playback : AnimationNodeStateMachinePlayback
@export var can_move : bool = true
signal Transitioned

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	pass
	
func Physics_Update(_delta: float) -> void:
	pass
