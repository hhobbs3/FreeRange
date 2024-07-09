extends TileMap

var moisture = FastNoiseLite.new()
var temerature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 10
var height = 5
@onready var player = get_parent().get_child(1)

func _ready():
	moisture.seed = randi()
	temerature.seed = randi()
	altitude.seed = randi()


func _process(delta):
	generate_chunk(player.position)
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, 0), 0, Vector2(0, 14))
		for y in range(height):
			set_cell(0, Vector2i(tile_pos.x-width/2 + x, 1 + y), 0, Vector2(0, 15))
		
		#for y in range(height):
		#	set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(0, 1))
