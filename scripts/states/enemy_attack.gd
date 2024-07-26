extends State
class_name EnemyAttack

@onready var timer = $Timer

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	if timer.time_left > 0:
		pass
	else:
		var direction = Vector2(0,0)
		#enemy.velocity.y = -100
		enemy.velocity = direction.normalized()
		print('attack')
		timer.start(1)

func _on_timer_timeout():
	print('end attack')
	print('switch to follow')
	Transitioned.emit(self, "Follow")
