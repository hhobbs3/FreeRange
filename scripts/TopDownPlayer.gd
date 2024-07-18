extends CharacterBody2D


const SPEED = 300.0
const ACCEL = 2


var input: Vector2

func get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	return input.normalized()
	
func _process(delta):
	var playerInput = get_input()
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	move_and_slide()
