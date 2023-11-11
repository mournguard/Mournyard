@tool
class_name AStarGrid3D extends AStar3D
## A 3D astar grid for simplified usage, similar to AStarGrid2D
## Bad

var _points = []
var _points_meta = []

var size: Vector3:
	set(v): size = v; _update()
	
func _update():
	clear()
	
	_points_meta = []
	_points_meta.resize(size.z * size.y * size.x)
	
	var i = 0
	_points = []
	_points.resize(size.z)
	for z in size.z:
		_points[z] = []
		_points[z].resize(size.y)
		for y in size.y:
			_points[z][y] = []
			_points[z][y].resize(size.x)
			for x in size.x:
				_points[z][y][x] = i
				_points_meta[index(Vector3(x,y,z))] = {}
				add_point(i, Vector3(x,y,z))
				i += 1
	for z in size.z:
		for y in size.y:
			for x in size.x:
				for dir in _valid_dirs(Vector3(x,y,z)):
					connect_points(_points[z][y][x], _points[z + dir.z][y + dir.y][x + dir.x])

func xyz(i) -> Vector3:
	var z = i / (size.y * size.x)
	i -= z * (size.y * size.x)
	var y = i / size.x
	var x = i % size.x
	return Vector3(x,y,z)

func index(xyz: Vector3) -> int:
	return xyz.z * (size.y * size.x) + xyz.y * size.x + xyz.x

func set_point_meta(point: Vector3, key: String, value):
	if not _has_point(point): return
	_points_meta[index(point)][key] = value

func get_point_meta(point: Vector3, key: String):
	if not _has_point(point): return
	return _points_meta[index(point)].get(key, null)

func get_set_point_meta(point: Vector3, key: String, value):
	if not _has_point(point): return
	var val = _points_meta[index(point)].get(key, null)
	_points_meta[index(point)][key] = value
	return val

func clear_meta_keys(keys: Array):
	for i in _points_meta.size():
		for key in keys:
			_points_meta[i][key] = null

func get_path(from: Vector3, to: Vector3) -> PackedVector3Array:
	if _has_point(from) and _has_point(to):
		return get_point_path(_points[from.z][from.y][from.x], _points[to.z][to.y][to.x])
	else: return PackedVector3Array()

func set_weight(pos: Vector3, weight: float) -> void:
	if _has_point(pos): 
		set_point_weight_scale(_points[pos.z][pos.y][pos.x], weight)
	
func _has_point(pos: Vector3) -> bool:
	if YardMagic.Vector3Any(pos, func(v): return v < 0): return false
	return _points.size() > pos.z and _points[pos.z].size() > pos.y and _points[pos.z][pos.y].size() > pos.x
	
func _valid_dirs(pos: Vector3) -> Array[Vector3]:
	var dirs:Array[Vector3] = []
	
	if pos.x > 0: dirs.push_back(Vector3.MODEL_RIGHT)
	if pos.x < size.x - 1: dirs.push_back(Vector3.MODEL_LEFT)
	
	if pos.y > 0: dirs.push_back(Vector3.MODEL_BOTTOM)
	if pos.y < size.y - 1: dirs.push_back(Vector3.MODEL_TOP)
	
	if pos.z > 0: dirs.push_back(Vector3.MODEL_REAR)
	if pos.z < size.z - 1: dirs.push_back(Vector3.MODEL_FRONT)
	
	return dirs
