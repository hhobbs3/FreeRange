extends State
class_name PlayerIdle


@export var move_speed := 0.0

var move_direction : Vector2
var wander_time : float
	
func Enter():
	print('enter idle')

	
	
func Update(delta: float):
	print('enter update')


func Physics_Update(_delta: float):
	print('enter physics update')

