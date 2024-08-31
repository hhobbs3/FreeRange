extends Weapon2D
class_name Gun2D

@onready var timer : Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	pass
	#update_facing_direction()
	#if Input.is_action_just_pressed('horizontal_attack') and can_attack:
	#	attack()
		
func attack() -> void:
	# gunshot sound
	sound_weapon.pitch_scale += randf_range(-0.05, 0.05)
	if sound_weapon.pitch_scale < -1.3 or sound_weapon.pitch_scale > 1.3:
		sound_weapon.pitch_scale = 1
	# bullet	
	var projectile_instance = projectile.instantiate()
	sound_weapon.play()
	projectile_instance.position = projectile_point.position
	projectile_instance.apply_impulse((Vector2(speed,0)).rotated(global_rotation))
	add_child(projectile_instance)
	can_attack = false
	timer.start(attack_rate)

func attack_alt() -> void:
	pass

# reload
func _on_timer_timeout() -> void:
	can_attack = true
