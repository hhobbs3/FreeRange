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
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: 
		randomize_wander()

func Physics_Update(_delta: float):
	# hit
	if enemy.hit:
		Transitioned.emit(self, "Damage")
	# falling
	if not enemy.is_on_floor():
		Transitioned.emit(self, "Fall")
	if enemy:
		enemy.velocity = move_direction * move_speed 
		var direction = player.global_position - enemy.global_position
		# near, follow
		if direction.length() < 120:
			Transitioned.emit(self, "Follow")
	# idle animation
	if enemy.velocity.length() > 0:
		enemy.animated_sprite_2d.play("run")
	if enemy.velocity.length() == 0:
		enemy.animated_sprite_2d.play("idle")
