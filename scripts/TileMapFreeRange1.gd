extends TileMap

var moisture = FastNoiseLite.new()
var temerature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var grass = FastNoiseLite.new()
var width = 100
var height = 50
@onready var canvas_layer = get_parent()
@onready var player = $"../../Player"

func _ready():
	moisture.seed = randi()
	temerature.seed = randi()
	altitude.seed = randi()
	grass.seed = randi()


func _process(delta):
	generate_chunk(player.position)
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		# randomize the tiles more
		# randomize the heights more
		var g = grass.get_noise_2d(tile_pos.x-width/2+x,0)
		
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, 1), 0, Vector2(round(g+2), 6))
		for y in range(height):
			set_cell(0, Vector2i(tile_pos.x-width/2 + x, 2 + y), 0, Vector2(0, 7))


