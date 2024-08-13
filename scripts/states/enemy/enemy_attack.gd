extends StateNPCEnemy
class_name EnemyAttack

@onready var timer = $Timer
@onready var enemy_area_horizontal_attack = $"../../EnemyAreaHorizontalAttack"
@onready var sprite_attack_box = $"../../EnemyAreaHorizontalAttack/EnemyCollisionHorizontalAttack/SpriteAttackBox"
@onready var sound_hiss = $"../../SoundHiss"

func Enter():
	pass

func Physics_Update(_delta: float):
	# hit
	if enemy.hit:
		Transitioned.emit(self, "Damage")
	if timer.time_left <= 0:
		enemy.enemy_collision_horizontal_attack.disabled = true
		sprite_attack_box.visible = false
		var direction = Vector2(0,0)
		#enemy.velocity.y = -100
		enemy.velocity = direction.normalized()
		sound_hiss.play()
		timer.start(1)
		
		enemy.animated_sprite_2d.play("attack")

func _on_timer_timeout():
	enemy.animated_sprite_2d.play('attack')
	# Handle attack
	enemy.enemy_collision_horizontal_attack.disabled = false
	sprite_attack_box.visible = true
	
	Transitioned.emit(self, "Follow")
