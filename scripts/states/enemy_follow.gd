extends State
class_name EnemyFollow

@export var move_speed := 80.0

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	if enemy.health <= 0:
		Transitioned.emit(self, "Die")
	var direction = Vector2(player.global_position.x - enemy.global_position.x,0)
	
	# too far, idle
	if direction.length() > 120:
		print('switch to idle')
		Transitioned.emit(self, "Idle")
		
	# near, follow
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
		enemy.animated_sprite_2d.play("run")
	else:
		# close, attack
		print('switch to attack')
		Transitioned.emit(self, "Attack")
		
	
