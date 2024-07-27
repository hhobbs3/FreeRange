extends State
class_name EnemyDie

@export var move_speed := 10.0
@onready var collision_snake = $"../../CollisionShape2DSnake"
@onready var character_snake = $"../.."
@onready var timer = $Timer

var move_direction : Vector2


func stop_moving():
	move_direction = Vector2(0,0)
	enemy.velocity = move_direction
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	stop_moving()
	
func Update(_delta: float):
	print('TIME TO DIE')
	stop_moving()
	timer.start()
	

func Physics_Update(_delta: float):
	character_snake.health = 0


func _on_timer_timeout():
	queue_free()
