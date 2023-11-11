@tool
@icon("res://addons/Mournyard/Icons/plan_path.svg")
class_name YardPath extends YardItemDraft

@export var path: Path3D

var requested_tiles = []

func _ready():
	super()
	set_meta("_edit_lock_", true)
	set_disable_scale(true)
	if _plan and not path:
		_init_path()
	else:
		path.curve_changed.connect(_on_curve_changed)
	_update()

func _color_changed(new_color: Color):
	_update()

func _init_path():
	var p = Path3D.new()
	p.curve = Curve3D.new()
	add_child(p)
	p.owner = owner
	p.set_meta("_edit_lock_", true)
	p.set_disable_scale(true)
	path = p
	path.curve_changed.connect(_on_curve_changed)

func _process(delta):
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	scale = Vector3.ONE
	
	path.position = Vector3.ZERO
	path.rotation = Vector3.ZERO
	path.scale = Vector3.ONE
	
	_snap_points()

func _on_curve_changed():
	_plan.content_changed.emit(_update)

func _snap_points():
	for c in path.curve.point_count:
		var pos = path.curve.get_point_position(c)
		var target = round(pos / YardConsts.TILE_SIZE) * YardConsts.TILE_SIZE
		target = Vector3(
			clampi(target.x, 0, (_plan.size.x - 1) * YardConsts.TILE_SIZE),
			clampi(target.y, 0, (_plan.size.y - 1) * YardConsts.TILE_SIZE),
			clampi(target.z, 0, (_plan.size.z - 1) * YardConsts.TILE_SIZE)
		)
		if not pos.is_equal_approx(target):
			path.curve.set_point_position(c, target)

func _update():
	if not is_inside_tree() or not path: return
	
	for c in path.get_children():
		path.remove_child(c)
		c.queue_free()
	
	requested_tiles = []
	
	var box_size = Vector3.ONE * YardConsts.TILE_SIZE

	for c in path.curve.point_count - 1:
		var p = _plan.get_astar().get_path(
			round((path.curve.get_point_position(c) + position) / YardConsts.TILE_SIZE),
			round((path.curve.get_point_position(c + 1) + position) / YardConsts.TILE_SIZE)
		)
		for pos in p:
			if not pos in requested_tiles:
				requested_tiles.push_back(pos)

	for pos in requested_tiles:
		pos += Vector3.ONE / 2
		var box_pos = pos * YardConsts.TILE_SIZE
		var box = YardDebug.Box.new(box_pos, box_size, _get_color(), false)
		path.add_child(box)

func _get_min():
	var min = Vector3.INF
	for c in path.curve.point_count:
		var pos = path.curve.get_point_position(c)
		if pos < min:
			min = pos
	return min
	
func _get_max():
	var max = -Vector3.INF
	for c in path.curve.point_count:
		var pos = path.curve.get_point_position(c)
		if pos > max:
			max = pos
	return max
