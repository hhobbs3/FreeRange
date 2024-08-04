extends StateNPCEnemy
class_name EnemyDie

@export var move_speed := 0.0
@onready var timer = $Timer

var move_direction : Vector2


func stop_moving():
	move_direction = Vector2(0,0)
	enemy.velocity = move_direction
	
func Enter():
	enemy.health = 0
	enemy.enemy_collision_horizontal_attack.disabled = true
	stop_moving()
	enemy.animated_sprite_2d.play("die")
	timer.start(1)

func Physics_Update(_delta: float):
	pass

func _on_timer_timeout():
	enemy.queue_free()
	pass
