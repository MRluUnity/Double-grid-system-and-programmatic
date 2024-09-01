extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tile_map : TileMapLayer = get_parent()
	var generate_creater : GenerateCreater = tile_map.get_parent()
	generate_creater.delete_prop(tile_map.local_to_map(position))
	queue_free()
