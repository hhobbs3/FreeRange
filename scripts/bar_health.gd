extends ProgressBar

@export var player: Player

func _ready():
	player.health_changed.connect(update)
	update()

func update():
	value = int(player.current_health * 100 / player.max_health)
