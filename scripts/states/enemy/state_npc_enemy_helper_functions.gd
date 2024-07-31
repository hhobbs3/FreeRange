extends Node

static func take_damage(area, enemy, damage):
	if area.is_in_group('player_attack'):
		print('DAMAGE')
		enemy.health -= damage
		print('enemy health = ' + str(enemy.health))
		return true
	return false
