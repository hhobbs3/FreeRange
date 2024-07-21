extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 10.0
@onready var collision_snake = $"../../CollisionShape2DSnake"

var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	if randi() % 3 == 0:
		move_direction = Vector2(0,0)
	else:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: 
		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
	
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < 60:
		print('switch to idle')
		Transitioned.emit(self, "Follow")
		
		
func _on_area_2d_area_entered(area):
	print('area1')
	print(area.get_groups())
	if area.is_in_group('hit'):
		enemy.health -= 1
		print(enemy.health)
		print('hit')
		Transitioned.emit(self, "Die")
