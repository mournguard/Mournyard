class_name YardItem extends Node3D

@export var tags: Array[String] = []

var rotation_index: int:
	get: return round(snapped_rotation.y / (PI/2))

var snapped_rotation: Vector3:
	get: return round(YardMagic.PositiveRotation(rotation) / (PI/2)) * PI/2

var _plan: YardPlan:
	get: _update_valid(); return _plan
var _prev_position: Vector3
var _prev_scale: Vector3
var _prev_rotation: Vector3

func _ready():
	_update_valid()
	
	_prev_position = global_position
	_prev_scale = scale
	_prev_rotation = rotation

func _process(delta):
	_update_position()
	scale = scale.snapped(Vector3.ONE).clamp(Vector3.ONE, Vector3.INF)
	rotation = snapped_rotation

	if _plan:
		if not _prev_position.is_equal_approx(global_position) or not _prev_scale.is_equal_approx(scale) or not _prev_rotation.is_equal_approx(rotation):
			_plan.content_changed.emit()
	
	_prev_position = global_position
	_prev_scale = scale
	_prev_rotation = rotation

func _color_changed(new_color: Color):
	pass

func _update_position():
	position = position.snapped(Vector3.ONE * YardConsts.TILE_SIZE)
	_apply_bounds()

func _apply_bounds():
	if not _plan: return
	position = Vector3(
		clampf(position.x, 0.0 + YardConsts.TILE_SIZE / 2, _plan.size.x * YardConsts.TILE_SIZE - YardConsts.TILE_SIZE / 2),
		clampf(position.y, 0.0, (_plan.size.y - 1) * YardConsts.TILE_SIZE),
		clampf(position.z, 0.0 + YardConsts.TILE_SIZE / 2, _plan.size.z * YardConsts.TILE_SIZE - YardConsts.TILE_SIZE / 2)
	)

func _update_valid():
	var p = get_parent()
	if p is YardPlan:
		_plan = p
	else:
		_plan = null

func _snap_vector(vector: Vector3) -> Vector3:
	return vector.snapped(Vector3.ONE * YardConsts.TILE_SIZE)
	
func _get_configuration_warnings():
	if self is YardTile:
		var p = get_parent()
		if not _plan and not EditorInterface.get_edited_scene_root() == self and not p is YardRoom:
			return ["This node should be used inside a `YardPlan` node."]
	if self is YardRoom:
		if not _plan and not EditorInterface.get_edited_scene_root() == self:
			return ["This node should be used inside a `YardPlan` node."]

func get_tag(tag: String) -> bool:
	if not tags: tags = []
	return tags.has(tag)

func set_tag(tag: String, value: bool) -> void:
	if not tags: tags = []
	if value and not tags.has(tag):
		tags.push_back(tag)
	elif not value and tags.has(tag):
		tags.erase(tag)
