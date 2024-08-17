extends Weapon2D
class_name Sword2D

# Called when the node enters the scene tree for the first time.
func _ready():
	guard_weapon = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#update_guard_direction()
	#if Input.is_action_just_pressed('horizontal_attack'):
	#	attack()

func attack():
	# sound
	sound_weapon.pitch_scale += randf_range(-0.05, 0.05)
	if sound_weapon.pitch_scale < -1.3 or sound_weapon.pitch_scale > 1.3:
		sound_weapon.pitch_scale = 1
	sound_weapon.play()
	
func attack_alt():
	pass


func _on_timer_timeout():
	pass # Replace with function body.
