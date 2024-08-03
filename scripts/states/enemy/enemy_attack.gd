extends StateNPCEnemy
class_name EnemyAttack

@onready var timer = $Timer
@onready var enemy_area_horizontal_attack = $"../../EnemyAreaHorizontalAttack"
@onready var sprite_attack_box = $"../../EnemyAreaHorizontalAttack/EnemyCollisionHorizontalAttack/SpriteAttackBox"

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	if timer.time_left <= 0:
		enemy.enemy_collision_horizontal_attack.disabled = true
		sprite_attack_box.visible = false
		var direction = Vector2(0,0)
		#enemy.velocity.y = -100
		enemy.velocity = direction.normalized()
		timer.start(1)
		enemy.animated_sprite_2d.play("attack")

func _on_timer_timeout():
	enemy.animated_sprite_2d.play('attack')
	# Handle attack
	enemy.enemy_collision_horizontal_attack.disabled = false
	sprite_attack_box.visible = true
	
	Transitioned.emit(self, "Follow")
	
func _on_hitbox_area_entered(area):
	var took_damage = StateNpcEnemyHelperFunctions.take_damage(area, enemy, 1)
	if took_damage:
		Transitioned.emit(self, "Damage")
