extends TileMap

var moisture = FastNoiseLite.new()
var temerature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 128
var height = 128
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
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var temp = temerature.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var alt = altitude.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			# if alt < 2:
			# 	set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(0, round(temp+10/5))) # select from specific column (3)
			# else:
			set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(round(moist+10/5), round(temp+10/5)))
