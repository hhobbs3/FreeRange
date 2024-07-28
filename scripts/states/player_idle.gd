extends StatePlayer
class_name PlayerIdle


@export var move_speed := 0.0

var move_direction : Vector2
var wander_time : float
	
func Enter():
	print('enter idle')
	
func Update(delta: float):
	pass

func Physics_Update(_delta: float):
	# Die
	if player:
		print('player health ' + str(player.current_health))
		if player.current_health <= 0:
			pass # Transitioned.emit(self, "Die")

	# Move
	
	
	# Jump
	
	# Attack
	
	# Idle
	# player.animated_sprite_2d.play('idle')

