extends State
class_name EnemyFollow

@export var enemy: CharacterNPC
@export var move_speed := 80.0

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	var direction = Vector2(player.global_position.x - enemy.global_position.x,0)
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
	
	#if direction.length() < 10:
	#	print('switch to die')
	#	Transitioned.emit(self, "Die")
	if enemy.health < 1:
		print('switch to die')
		Transitioned.emit(self, "Die")
		
	if direction.length() > 120:
		print('switch to idle')
		Transitioned.emit(self, "Idle")
	
	if direction.length() < 40:
		print('switch to idle')
		Transitioned.emit(self, "Follow")
		
		
func _on_area_2d_area_entered(area):
	print('area2')
	print(area.get_groups())
	if area.is_in_group('hit'):
		enemy.health -= 1


func _on_area_2d_body_entered(body):
	print('body2')
	print(body.get_groups())
	if body.is_in_group('Player'):
		enemy.health -= 1
