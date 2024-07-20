extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 80.0

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	var direction = Vector2(player.global_position.x - enemy.global_position.x,0)
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
		
	if direction.length() > 120:
		print('switch to idle')
		Transitioned.emit(self, "Idle")
	if direction.length() < 10:
		print('switch to die')
		Transitioned.emit(self, "Die")
