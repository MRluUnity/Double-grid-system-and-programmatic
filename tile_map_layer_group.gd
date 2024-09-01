class_name GenerateCreater extends Node2D

@onready var char_map_layer: DoubleMapLayer = $CharMapLayer
@onready var display_map_layer: TileMapLayer = $DisplayMapLayer
@onready var prop_tile_map_layer: TileMapLayer = $PropTileMapLayer
@onready var player: CharacterBody2D = %Player

@export var block_size : int = 32
@export var load_range_radius : int = 4

var noise : FastNoiseLite

var target_pos : Vector2
var current_block_pos : Vector2

var blocks : Array[Vector2]

var generate : Dictionary = {}
var props : Dictionary = {}

func _ready() -> void:
	randomize()
	
	noise = FastNoiseLite.new()
	
	noise.seed = randi()
	generate_block()

func _process(delta: float) -> void:
	target_pos = player.global_position
	process_block_coords()

func process_block_coords() -> void:
	var block_coords : Vector2 = to_block_pos(target_pos)
	
	if current_block_pos != block_coords:
		current_block_pos = block_coords
		generate_block()

func generate_block() -> void:
	var start_block : Vector2 = current_block_pos - Vector2(load_range_radius, load_range_radius)
	var end_block : Vector2 = current_block_pos + Vector2(load_range_radius, load_range_radius) + Vector2.ONE

	var temp_blocks : Array[Vector2] = []
	var remove_blocks : Array[Vector2] = []
	
	for x in range(start_block.x, end_block.x):
		for y in range(start_block.y, end_block.y):
			temp_blocks.append(Vector2(x, y))
	
	for coords in blocks:
		if not temp_blocks.has(coords):
			remove_blocks.append(coords)
			remove_block(coords)
	
	for coords in remove_blocks:
		blocks.erase(coords)
	
	for coords in temp_blocks:
		if not blocks.has(coords):
			blocks.append(coords)
			add_block(coords)


func add_block(coords : Vector2) -> void:
	print("-------->加载区块：%s" % coords)
	
	for x in range(coords.x * block_size, coords.x * block_size + block_size):
		for y in range(coords.y * block_size, coords.y * block_size + block_size):
			create_tile(Vector2(x, y))

func remove_block(coords : Vector2) -> void:
	print("-------->卸载区块：%s" % coords)
	
	for x in range(coords.x * block_size, coords.x * block_size + block_size):
		for y in range(coords.y * block_size, coords.y * block_size + block_size):
			delete_tile(Vector2(x, y))
			delete_prop(Vector2(x, y))

func create_tile(coords : Vector2) -> void:
	var main_value : float
	
	if generate.has(coords):
		main_value = generate[coords]
		if main_value == .1:
			char_map_layer.set_cell(coords, 0, char_map_layer.grass_tile_set)
		elif main_value == .2:
			char_map_layer.set_cell(coords, 0, char_map_layer.dirt_tile_set)
	else :
		main_value = noise.get_noise_2d(coords.x, coords.y)
		if main_value > .16:
			char_map_layer.set_cell(coords, 0, char_map_layer.dirt_tile_set)
		elif main_value <= .16:
			char_map_layer.set_cell(coords, 0, char_map_layer.grass_tile_set)
			
	char_map_layer.set_display_tile(coords)
	
	save_tile(coords)
	
	if props.has(coords):
		main_value = props[coords]
		if main_value == .15:
			prop_tile_map_layer.set_cell(coords, 2, Vector2.ZERO, 1)
		elif main_value == .25:
			prop_tile_map_layer.set_cell(coords, 2, Vector2.ZERO, 2)
	else :
		main_value = noise.get_noise_2d(coords.x, coords.y)
		if main_value > -.3 and main_value < 0:
			var tree_index : int = randi() % 100
			if tree_index < 10:
				prop_tile_map_layer.set_cell(coords, 2, Vector2.ZERO, 2)
		
		if main_value > -.2 and main_value < -.05:
			var flower_index : int = randi() % 100
			if flower_index < 20:
				prop_tile_map_layer.set_cell(coords, 2, Vector2.ZERO, 1)
	save_prop(coords)

func delete_tile(coords : Vector2) -> void:
	save_tile(coords)
	char_map_layer.erase_cell(coords)
	char_map_layer.set_display_tile(coords)

	
func delete_prop(coords : Vector2) -> void:
	save_prop(coords)
	prop_tile_map_layer.erase_cell(coords)


func save_tile(coords : Vector2) -> void:
	if char_map_layer.get_cell_atlas_coords(coords) == char_map_layer.grass_tile_set:
		generate[coords] = .1
	elif char_map_layer.get_cell_atlas_coords(coords) == char_map_layer.dirt_tile_set:
		generate[coords] = .2

func save_prop(coords : Vector2) -> void:
	if props.has(coords):
		if props[coords] != prop_tile_map_layer.get_cell_alternative_tile(coords):
			if prop_tile_map_layer.get_cell_alternative_tile(coords) == 1:
				props[coords] = .15
			elif prop_tile_map_layer.get_cell_alternative_tile(coords) == 2:
				props[coords] = .25
			else :
				props[coords] = 0
	
	if prop_tile_map_layer.get_cell_alternative_tile(coords) == 1:
		props[coords] = .15
	elif prop_tile_map_layer.get_cell_alternative_tile(coords) == 2:
		props[coords] = .25
	else :
		props[coords] = 0

func to_block_pos(screen_pos:Vector2):
	return floor(screen_pos / (Vector2(block_size, block_size) * Vector2(char_map_layer.tile_set.tile_size)))

func _on_button_pressed() -> void:
	randomize()
	
	noise = FastNoiseLite.new()
	
	noise.seed = randi()
	
	print("加载第一个区块")
	add_block(Vector2.ZERO)
