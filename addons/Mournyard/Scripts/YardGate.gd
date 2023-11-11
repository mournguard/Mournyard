@tool
@icon("res://addons/Mournyard/Icons/gate.svg")
class_name YardGate extends Node3D

var _prev_position: Vector3

func _ready() -> void:
	set_disable_scale(true)
	_prev_position = position

func _process(delta):
	position = position.snapped(Vector3.ONE * YardConsts.TILE_SIZE)
	scale = Vector3.ONE
	rotation = Vector3.ZERO
	
	if not _prev_position.is_equal_approx(global_position):
		_draw_box()
	
	_prev_position = global_position

func _draw_box():
	if not is_inside_tree(): return
	
	for c in get_children():
		if c is YardDebug.Box:
			remove_child(c)
			c.queue_free()
	
	#if _plan.is_editing():
	var color = Color.REBECCA_PURPLE
	var size: Vector3 = Vector3.ONE
	var pos = _snap_vector(
		_snap_vector(global_position) - size * (YardConsts.TILE_SIZE / 2)
	)

	# Offset by half moves it away from the center and realigns it with the grid
	# Makes the origin weird but that might be fixed with a custom control gizmo later
	pos += size * YardConsts.TILE_SIZE / 2

	var box = YardDebug.Box.new(pos - _snap_vector(global_position), size * YardConsts.TILE_SIZE, color, false)
	add_child(box)
	
func _snap_vector(vector: Vector3) -> Vector3:
	return vector.snapped(Vector3.ONE * YardConsts.TILE_SIZE)

## Add warnings to make sure the user places the node in the right place
func _get_configuration_warnings():
	var p = get_parent()
	if not p is YardPlan:
		return ["`YardGate` nodes should only be added as children of `YardRoom` nodes."]
	else: return []
