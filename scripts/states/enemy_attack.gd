extends State
class_name EnemyAttack

@onready var timer = $Timer
@onready var enemy_area_horizontal_attack = $"../../EnemyAreaHorizontalAttack"
@onready var sprite_attack_box = $"../../EnemyAreaHorizontalAttack/EnemyCollisionHorizontalAttack/SpriteAttackBox"

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	if enemy.health <= 0:
		Transitioned.emit(self, "Die")
	if timer.time_left <= 0:
		enemy.enemy_collision_horizontal_attack.disabled = true
		sprite_attack_box.visible = false
		var direction = Vector2(0,0)
		#enemy.velocity.y = -100
		enemy.velocity = direction.normalized()
		print('attack')
		timer.start(1)

func _on_timer_timeout():
	print('end attack')
	print('switch to follow')
	enemy.animated_sprite_2d.play('attack')
	# Handle attack
	print('horizontal_attack player')
	enemy.enemy_collision_horizontal_attack.disabled = false
	sprite_attack_box.visible = true
	
	Transitioned.emit(self, "Follow")
