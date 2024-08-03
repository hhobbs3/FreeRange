extends StatePlayer
class_name PlayerDie
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func Enter():
	if player.current_health <= 0:
		Engine.time_scale = 0.5
		# player.animated_sprite_2d.play("die")
		player.velocity.y -= 100
		var player_collision = player.get_node("CollisionShape2D")
		if player_collision:
			player_collision.queue_free()
		timer.start(2)
	else:
		Transitioned.emit(self, "Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_timer_timeout():
	print("RESTART")
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	
	
