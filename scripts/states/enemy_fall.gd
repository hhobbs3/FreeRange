extends StateNPCEnemy
class_name EnemyFall

@export var move_speed := 80.0

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	if enemy:
		#if enemy.health <= 0:
		#	Transitioned.emit(self, "Die")
		print('falling')
		enemy.velocity.y += gravity * delta
		if enemy.is_on_floor():
			Transitioned.emit(self, "Idle")
		
	
