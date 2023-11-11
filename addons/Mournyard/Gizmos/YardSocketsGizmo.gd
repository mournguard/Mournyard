# TODO: Implement Undo/Redo for handles 
class_name YardSocketsGizmo extends EditorNode3DGizmoPlugin

const GATE_ARROW = preload("res://addons/Mournyard/Gizmos/GateArrow.tscn")
const GATE_ARROW_TEXTURE_ON = preload("res://addons/Mournyard/Images/gate_arrow.png")
const GATE_ARROW_TEXTURE_OFF = preload("res://addons/Mournyard/Images/gate_arrow_off.png")
const SOCKET_TEXTURE_ON = preload("res://addons/Mournyard/Images/socket_on.png")
const SOCKET_TEXTURE_OFF = preload("res://addons/Mournyard/Images/socket_off.png")

var object: Object
var handle_alphas: Array[float] = []
var hovered_arrows: Array[YardConnection] = []
var arrow_mesh: MeshInstance3D

func _init():
	for i in 11:
		create_handle_material("handles_on_" + str(i))
		var on = get_material("handles_on_" + str(i))
		on.albedo_color = 0x30dd69ff
		on.albedo_color.a = i/10.0
		on.albedo_texture = SOCKET_TEXTURE_ON

		create_handle_material("handles_off_" + str(i))
		var off = get_material("handles_off_" + str(i))
		off.albedo_color = 0xff0000ff
		off.albedo_color.a = i/10.0
		off.albedo_texture = SOCKET_TEXTURE_OFF
		
	arrow_mesh = GATE_ARROW.instantiate()

func _get_line_color() -> Color:
	var color = Color.hex(0x0090ffff)
	return color

func _get_gizmo_name():
	return "Mournyard | Sockets"

func _commit_handle(gizmo, handle_id, secondary, restore, cancel):
	if not object.editing: return
	object.node.toggle_socket_from_id(handle_id)
	_redraw(gizmo)

func _redraw(gizmo: EditorNode3DGizmo):
	object = gizmo.get_node_3d()
	gizmo.clear()
	
	if handle_alphas.size():
		for i in handle_alphas.size():
			handle_alphas[i] = max(handle_alphas[i] - 0.02, 0)
	else:
		handle_alphas = []
		handle_alphas.resize(object.node.get_socket_count())
	
	if object.editing:
		_add_lines(gizmo)
		_add_handles(gizmo)
		_add_arrows(gizmo)

func _add_lines(gizmo) -> void:
	if not object: return
	
	create_material("lines", _get_line_color())
	
	var lines = PackedVector3Array()
	var size = YardConsts.TILE_SIZE
	
	lines.push_back(Vector3(-size / 2.0, 0, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0 + 1, 0, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0, 0, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0, 0, - size / 2.0 + 1))
	lines.push_back(Vector3(-size / 2.0, 0, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0, 1, - size / 2.0))
	
	lines.push_back(Vector3(size / 2.0, 0, - size / 2.0))
	lines.push_back(Vector3(size / 2.0 - 1, 0, - size / 2.0))
	lines.push_back(Vector3(size / 2.0, 0, - size / 2.0))
	lines.push_back(Vector3(size / 2.0, 0, - size / 2.0 + 1))
	lines.push_back(Vector3(size / 2.0, 0, - size / 2.0))
	lines.push_back(Vector3(size / 2.0, 1, - size / 2.0))
	
	lines.push_back(Vector3(-size / 2.0, 0, size / 2.0))
	lines.push_back(Vector3(-size / 2.0 + 1, 0, size / 2.0))
	lines.push_back(Vector3(-size / 2.0, 0, size / 2.0))
	lines.push_back(Vector3(-size / 2.0, 0, size / 2.0 - 1))
	lines.push_back(Vector3(-size / 2.0, 0, size / 2.0))
	lines.push_back(Vector3(-size / 2.0, 1, size / 2.0))
	
	lines.push_back(Vector3(size / 2.0, 0, size / 2.0))
	lines.push_back(Vector3(size / 2.0 - 1, 0, size / 2.0))
	lines.push_back(Vector3(size / 2.0, 0, size / 2.0))
	lines.push_back(Vector3(size / 2.0, 0, size / 2.0 - 1))
	lines.push_back(Vector3(size / 2.0, 0, size / 2.0))
	lines.push_back(Vector3(size / 2.0, 1, size / 2.0))
	
	lines.push_back(Vector3(-size / 2.0, size, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0 + 1, size, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0, size, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0, size, - size / 2.0 + 1))
	lines.push_back(Vector3(-size / 2.0, size, - size / 2.0))
	lines.push_back(Vector3(-size / 2.0, size - 1, - size / 2.0))
	
	lines.push_back(Vector3(size / 2.0, size, - size / 2.0))
	lines.push_back(Vector3(size / 2.0 - 1, size, - size / 2.0))
	lines.push_back(Vector3(size / 2.0, size, - size / 2.0))
	lines.push_back(Vector3(size / 2.0, size, - size / 2.0 + 1))
	lines.push_back(Vector3(size / 2.0, size, - size / 2.0))
	lines.push_back(Vector3(size / 2.0, size - 1, - size / 2.0))
	
	lines.push_back(Vector3(-size / 2.0, size, size / 2.0))
	lines.push_back(Vector3(-size / 2.0 + 1, size, size / 2.0))
	lines.push_back(Vector3(-size / 2.0, size, size / 2.0))
	lines.push_back(Vector3(-size / 2.0, size, size / 2.0 - 1))
	lines.push_back(Vector3(-size / 2.0, size, size / 2.0))
	lines.push_back(Vector3(-size / 2.0, size - 1, size / 2.0))
	
	lines.push_back(Vector3(size / 2.0, size, size / 2.0))
	lines.push_back(Vector3(size / 2.0 - 1, size, size / 2.0))
	lines.push_back(Vector3(size / 2.0, size, size / 2.0))
	lines.push_back(Vector3(size / 2.0, size, size / 2.0 - 1))
	lines.push_back(Vector3(size / 2.0, size, size / 2.0))
	lines.push_back(Vector3(size / 2.0, size - 1, size / 2.0))
	
	gizmo.add_lines(lines, get_material("lines", gizmo), false)

## Registers all the handles (There are many)
func _add_handles(gizmo) -> void:
	if not object: return
	
	var on_handles = PackedVector3Array()
	var off_handles = PackedVector3Array()
	
	for i in object.node.get_socket_count():
		var alpha = str(round(handle_alphas[i]*10))
		var material = get_material("handles_on_" + alpha, gizmo) if object.node.get_socket_from_id(i) else get_material("handles_off_" + alpha)
		gizmo.add_handles([_get_handle_position(i)], material, [])

func _add_arrows(gizmo) -> void:
	for connection in object.node.connections:
		if connection.is_vertical(): continue
		
		var material = arrow_mesh.material_override.duplicate()
		material.albedo_texture = GATE_ARROW_TEXTURE_ON if connection.gate or connection in hovered_arrows else GATE_ARROW_TEXTURE_OFF
		material.albedo_color = 0x0092ffff if connection.gate else 0xaaaaaa22
		#material.albedo_color.a = 1.0 if connection.gate else 0.1
		
		var transform = arrow_mesh.transform
		var direction = Vector3(connection.direction).rotated(Vector3.UP, -PI/2.0 * object.rotation_index)
		
		transform = transform.rotated(Vector3.UP, Vector3.BACK.signed_angle_to(direction, Vector3.UP))
		transform.origin += _get_arrow_position(direction)
		
		gizmo.add_mesh(arrow_mesh.mesh, material, transform)

func _get_handle_position(handle_id: int, adjust: bool = true):
	var connection = object.node.get_connection_from_id(handle_id)
	var index = object.node.connections.find(connection)
	var direction = Vector3(connection.direction).rotated(Vector3.UP, -PI/2.0 * object.rotation_index if adjust else 0)
	return id_to_position(handle_id, direction, index)

func _get_arrow_position(dir: Vector3) -> Vector3:
	return dir * YardConsts.TILE_SIZE / 1.25

func _subgizmos_intersect_ray(gizmo, camera, screen_pos):
	if not object.editing: return -1
	var closest_handle = -1
	var closest_arrow = null
	
	var closest_dist = INF
	for i in object.node.get_socket_count():
		var pos = _get_handle_position(i) + object.position
		var dist = camera.unproject_position(pos).distance_to(screen_pos)
		if dist < closest_dist:
			closest_handle = i
			closest_dist = dist

	for c in object.node.connections:
		if c.is_vertical(): continue
		var position = _get_arrow_position(c.direction)
		var dist = camera.unproject_position(object.position + position).distance_to(screen_pos)
		if dist < closest_dist:
			closest_handle = -1
			closest_arrow = c
			closest_dist = dist

	if closest_handle != -1 and closest_dist <= YardConsts.HANDLE_SELECT_DISTANCE:
		object.node.toggle_socket_from_id(closest_handle)
		object.clear_subgizmo_selection()
		return closest_handle
	elif closest_arrow and closest_dist <= YardConsts.ARROW_SELECT_DISTANCE:
		closest_arrow.gate = !closest_arrow.gate
		return 0

	return -1

func _has_gizmo(object: Node3D) -> bool:
	var node = object.get('node')
	return node and node is YardNode

func id_to_position(handle_id: int, direction: Vector3, index: int):
	var size = YardConsts.TILE_SIZE
	var ss = YardConsts.NODE_CONNECTION_SIZE
	var offset: Vector3
	var id = handle_id - (index * ss*ss)
	
	if direction.is_equal_approx(Vector3.UP):
		offset = Vector3(id % ss, 0, id / ss)
		return offset / (Vector3.ONE * (ss - 1)) * size + Vector3(-0.5, 1 + 0.1, -0.5) * size
	elif direction.is_equal_approx(Vector3.DOWN):
		offset = Vector3(-id % ss, 0, (id - id % ss) / ss)
		return offset / (Vector3.ONE * (ss - 1)) * size + Vector3(0.5, 0 - 0.1, -0.5) * size
	elif direction.is_equal_approx(Vector3.LEFT):
		offset = Vector3(0, -id / ss, id % ss)
		return offset / (Vector3.ONE * (ss - 1)) * size + Vector3(-0.5 - 0.1, 1, -0.5) * size
	elif direction.is_equal_approx(Vector3.RIGHT):
		offset = Vector3(0, -id / ss, -id % ss)
		return offset / (Vector3.ONE * (ss - 1)) * size + Vector3(0.5 + 0.1, 1, 0.5) * size
	elif direction.is_equal_approx(Vector3.BACK):
		offset = Vector3(id % ss, -id / ss, 0)
		return offset / (Vector3.ONE * (ss - 1)) * size + Vector3(-0.5, 1, 0.5 + 0.1) * size
	elif direction.is_equal_approx(Vector3.FORWARD):
		offset = Vector3(-id % ss, -id / ss, 0)
		return offset / (Vector3.ONE * (ss - 1)) * size + Vector3(0.5, 1, -0.5 - 0.1) * size
	
	return Vector3.ZERO
