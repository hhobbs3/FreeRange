extends StateNPCEnemy
class_name EnemyFollow

@export var move_speed := 80.0

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	# falling
	if not enemy.is_on_floor():
		Transitioned.emit(self, "Fall")
		
	var direction = Vector2(player.global_position.x - enemy.global_position.x,0)
	
	# too far, idle
	if direction.length() > 120:
		Transitioned.emit(self, "Idle")
		
	# near, follow
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
		enemy.animated_sprite_2d.play("run")
	elif enemy.health > 0:
		# close, attack
		Transitioned.emit(self, "Attack")
		
func _on_hitbox_area_entered(area):
	var took_damage = StateNpcEnemyHelperFunctions.take_damage(area, enemy, 1)
	if took_damage:
		Transitioned.emit(self, "Damage")
