class_name DoubleMapLayer extends TileMapLayer

@onready var display_map_layer: TileMapLayer = $"../DisplayMapLayer"

enum TileType {
	Null,
	Grass,
	Dirt
}

@export var grass_tile_set : Vector2i = Vector2.ZERO
@export var dirt_tile_set : Vector2i = Vector2.RIGHT

const FOUR_CELLS : Array[Vector2i] = [Vector2i.ZERO, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.ONE]
const grass_and_drit = {
	Vector2i(2, 1) : [TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass], # 草
	Vector2i(1, 3) : [TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Grass], # 右下角草
	Vector2i(0, 0) : [TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Dirt], # 左下角草
	Vector2i(0, 2) : [TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Dirt], # 右上角草
	Vector2i(3, 3) : [TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Dirt], # 左上角草
	Vector2i(1, 0) : [TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Grass], # 右半边草
	Vector2i(3, 2) : [TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Dirt], # 左半边草
	Vector2i(3, 0) : [TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Grass], # 下半边草
	Vector2i(1, 2) : [TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Dirt], # 上半边草
	Vector2i(1, 1) : [TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Grass], # 左上角泥
	Vector2i(2, 0) : [TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Grass], # 右上角泥
	Vector2i(2, 2) : [TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Grass], # 左下角泥
	Vector2i(3, 1) : [TileType.Grass, TileType.Grass, TileType.Grass, TileType.Dirt], # 右下角泥
	Vector2i(2, 3) : [TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Dirt], # 左上与右下泥
	Vector2i(0, 1) : [TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Grass], # 左上与右下草
	Vector2i(0, 3) : [TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Dirt]  # 泥
}

func _ready() -> void:
	for coord : Vector2i in get_used_cells():
		set_display_tile(coord)
		
func set_display_tile(pos : Vector2i) -> void:
	for i in FOUR_CELLS:
		var new_pos : Vector2i = pos + i
		calculate_display_tile(new_pos)
		
func calculate_display_tile(new_pos : Vector2i) -> void:
	var up_left : TileType = get_cell_tile(new_pos - FOUR_CELLS[3])
	var up_right : TileType = get_cell_tile(new_pos - FOUR_CELLS[2])
	var down_left : TileType = get_cell_tile(new_pos - FOUR_CELLS[1])
	var down_right : TileType = get_cell_tile(new_pos - FOUR_CELLS[0])
	
	var tile_pos : Vector2i = grass_and_drit.find_key([up_left, up_right, down_left, down_right])
	
	display_map_layer.set_cell(new_pos, 1, tile_pos)

func get_cell_tile(coord : Vector2i) -> TileType:
	var atlas_coord : Vector2i = get_cell_atlas_coords(coord)
	if atlas_coord == grass_tile_set:
		return TileType.Grass
	else :
		return TileType.Dirt
