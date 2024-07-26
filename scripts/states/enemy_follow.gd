extends State
class_name EnemyFollow

@export var enemy: CharacterNPC
@export var move_speed := 80.0

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	var direction = Vector2(player.global_position.x - enemy.global_position.x,0)
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		Transitioned.emit(self, "Attack")
		
	if direction.length() > 120:
		print('switch to idle')
		Transitioned.emit(self, "Idle")
		
		
func _on_area_2d_area_entered(area):
	print('area2')
	if area.is_in_group('hit'):
		take_damage(1)


func _on_area_2d_body_entered(body):
	print('body2')
	if body.is_in_group('Player'):
		take_damage(1)
		
func take_damage(damage):
	enemy.health -= damage
	if enemy.health <= 0:
		print('switch to die')
		Transitioned.emit(self, "Die")
