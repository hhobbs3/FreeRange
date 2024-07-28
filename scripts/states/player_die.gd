extends StatePlayer
class_name PlayerDie
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.current_health <= 0:
		player.animated_sprite_2d.play("die")
		timer.start(2)
	else:
		Transitioned.emit(self, "Idle")
	
	
func _on_timer_timeout():
	print('PLAYER DIED')
	get_tree().reload_current_scene()
	
	
