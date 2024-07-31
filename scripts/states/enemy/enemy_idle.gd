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
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: 
		randomize_wander()

func Physics_Update(_delta: float):
	#	Transitioned.emit(self, "Die")
	# falling
	if not enemy.is_on_floor():
		print('not on floor')
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
		
func _on_hitbox_area_entered(area):
	var took_damage = StateNpcEnemyHelperFunctions.take_damage(area, enemy, 1)
	if took_damage:
		Transitioned.emit(self, "Damage")
