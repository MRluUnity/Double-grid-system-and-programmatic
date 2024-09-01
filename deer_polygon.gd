@tool
class_name DeerPolygon extends Polygon2D


@export var polygon_edge : int = 3:
	set(v):
		polygon_edge = v
		if polygon_edge < 3:
			polygon_edge = 3
			push_error("多边形必须有三条边")
		create_polygon()

@export var polygon_length : float = 32:
	set(v):
		polygon_length = v
		if polygon_length <= 0:
			polygon_length = .01
			push_error("多边形的变长不能为0")
		create_polygon()


func _ready() -> void:
	create_polygon()


func create_polygon() -> void:
	# 将角度转化为弧度
	var polygon_rad = deg_to_rad(360 / polygon_edge)
	# 临时点变量
	var point : Vector2
	# 临时点集合
	var points : Array[Vector2] = []

	# 使用for循环进行点的创建
	for point_index in polygon_edge:
		# 根据上一个点的坐标和弧度创建下一个点
		point.x = cos(point_index * polygon_rad) * polygon_length
		point.y = sin(point_index * polygon_rad) * polygon_length
		points.append(point)

	# 将临时点集合的数据赋值给多边形数组中
	polygon = points


	if not get_parent(): return

	# 使用卫语法判断父级是否是一个多边形碰撞体，不是就跳过
	for i in get_parent().get_children():
		if i is CollisionPolygon2D:
			i.polygon = polygon

			return
	# 如果没被卫语法排除，就把父级的多边形碰撞体的多边形数组与当前多边形同步
