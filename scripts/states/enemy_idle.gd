extends StateNPCEnemy
class_name EnemyIdle
@export var move_speed := 0.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	
	if randi() % 3 == 0:
		move_direction = Vector2(0,0)
	else:
		move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	
	wander_time = randf_range(1, 3)
	
func Enter():
	print('enter idle')
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	
func Update(delta: float):
	print('enter update')
	if wander_time > 0:
		wander_time -= delta
	else: 
		randomize_wander()

func Physics_Update(_delta: float):
	print('enter physics update')
	if enemy.health <= 0:
		Transitioned.emit(self, "Die")
	if enemy:
		enemy.velocity = move_direction * move_speed 
		var direction = player.global_position - enemy.global_position
		# near, follow
		if direction.length() < 120:
			print('switch to follow')
			Transitioned.emit(self, "Follow")
	# animation
	if enemy.velocity.length() > 0:
		enemy.animated_sprite_2d.play("run")
	if enemy.velocity.length() == 0:
		enemy.animated_sprite_2d.play("idle")
