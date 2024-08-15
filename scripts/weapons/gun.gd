extends Weapon2D
class_name Gun2D

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_facing_direction()
	if Input.is_action_just_pressed('horizontal_attack') and can_fire:
		fire()
		
func fire():
	# gunshot sound
	sound_weapon.pitch_scale += randf_range(-0.05, 0.05)
	if sound_weapon.pitch_scale < -1.3 or sound_weapon.pitch_scale > 1.3:
		sound_weapon.pitch_scale = 1
	# bullet	
	var projectile_instance = projectile.instantiate()
	sound_weapon.play()
	projectile_instance.position = projectile_point.position
	projectile_instance.apply_impulse((Vector2(speed,0)).rotated(rotation))
	add_child(projectile_instance)
	can_fire = false
	timer.start(fire_rate)

# reload
func _on_timer_timeout():
	can_fire = true
