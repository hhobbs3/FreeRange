extends TileMap

const DIRT = 0

@onready var noise = $Noise.texture.noise

func _ready():
	#randomize()
	#noise.seed = randi() % 1000
	for x in 100:
		for y in 100:
			if noise.get_noise_2d(x, y) > 0:
				set_cell(0, Vector2i(x,y), 0, Vector2(0,0), 0)
				
