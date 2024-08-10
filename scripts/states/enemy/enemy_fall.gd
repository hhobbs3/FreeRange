extends StateNPCEnemy
class_name EnemyFall

@export var move_speed := 80.0

func Enter():
	pass

func Physics_Update(delta: float):
	if enemy:
		# hit
		if enemy.hit:
			Transitioned.emit(self, "Damage")
		enemy.velocity.y += gravity * delta
		if enemy.is_on_floor():
			Transitioned.emit(self, "Idle")
