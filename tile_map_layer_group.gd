class_name GenerateCreater extends Node2D

@onready var char_map_layer: DoubleMapLayer = $CharMapLayer
@onready var display_map_layer: TileMapLayer = $DisplayMapLayer

@export var block_size : int = 32

var noise : FastNoiseLite

func _ready() -> void:
	randomize()
	
	noise = FastNoiseLite.new()
	
	noise.seed = randi()
	
	print("加载第一个区块")
	add_block(Vector2.ZERO)

func add_block(coord : Vector2) -> void:
	print("-------->加载区块：%s" % coord)
	
	for x in range(coord.x * block_size, coord.x * block_size + block_size):
		for y in range(coord.y * block_size, coord.y * block_size + block_size):
			create_tile(Vector2(x, y))

func create_tile(coord : Vector2) -> void:
	var main_value : float = noise.get_noise_2d(coord.x, coord.y)
	
	if main_value < .16:
		char_map_layer.set_cell(coord, 0, char_map_layer.dirt_tile_set)
	if main_value >= .16:
		char_map_layer.set_cell(coord, 0, char_map_layer.grass_tile_set)
	
	char_map_layer.set_display_tile(coord)
