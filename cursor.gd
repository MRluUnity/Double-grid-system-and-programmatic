extends Node2D

@export var cell_size : Vector2i = Vector2i(256, 256)
@onready var grid: ColorRect = %Grid


var target_pos : Vector2

func to_cell_pos(pos : Vector2) -> Vector2:
	return floor(pos / Vector2(cell_size))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos : Vector2 = get_global_mouse_position()
		target_pos = to_cell_pos(mouse_pos) * Vector2(cell_size)

func _process(delta: float) -> void:
	global_position = target_pos + Vector2(cell_size / 2)
	grid.global_position = get_global_mouse_position() + Vector2(-672, -672)
