extends StateNPCEnemy
class_name EnemyDamage

@export var move_speed := 0.0
@onready var timer = $Timer

var move_direction : Vector2


func stop_moving():
	move_direction = Vector2(0,0)
	enemy.velocity = move_direction
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	var direction = Vector2(-(player.global_position.x - enemy.global_position.x),-(player.global_position.y - enemy.global_position.y))
	enemy.enemy_collision_horizontal_attack.disabled = true
	enemy.velocity = direction
	enemy.animated_sprite_2d.play("damage")
	timer.start(0.5)

func Physics_Update(_delta: float):
	pass

func _on_timer_timeout():
	stop_moving()
	# never seems to make it here
	if enemy.health <= 0:
		Transitioned.emit(self, "Die")
	else:
		Transitioned.emit(self, "Idle")
	
