extends State
class_name StateNPCEnemy

@export var enemy: CharacterNPC

var player: CharacterBody2D


func _on_area_2d_area_entered(area):
	if area.is_in_group('player_attack'):
		take_damage(1)
		
func _on_area_2d_area_exited(area):
	if area.is_in_group('player_attack'):
		take_damage(1)

func take_damage(damage):
	enemy.health -= damage
	Transitioned.emit(self, "Damage")
