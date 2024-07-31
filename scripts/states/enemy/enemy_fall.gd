extends StateNPCEnemy
class_name EnemyFall

@export var move_speed := 80.0

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity.y += gravity * delta
		if enemy.is_on_floor():
			Transitioned.emit(self, "Idle")
		
	
func _on_hitbox_area_entered(area):
	var took_damage = StateNpcEnemyHelperFunctions.take_damage(area, enemy, 1)
	if took_damage:
		Transitioned.emit(self, "Damage")
