class_name YardDebug extends MeshInstance3D

static var _mat: StandardMaterial3D

static func _init_material() -> void:
	_mat = StandardMaterial3D.new()
	#_mat.no_depth_test = true
	_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_mat.vertex_color_use_as_albedo = true
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

var _die: bool = true

func _init(die: bool):
	mesh = ImmediateMesh.new()
	if not _mat: _init_material()
	set_material_override(_mat)
	_die = die
	
func _physics_process(_delta):
	if not _die: return
	mesh.clear_surfaces()
	if is_inside_tree():
		get_parent().remove_child(self)
	queue_free()

class Line extends YardDebug:
	func _init(from: Vector3, to: Vector3, color: Color = Color.RED, die: bool = true):
		if Engine.is_editor_hint():
			super(die)
			mesh.surface_begin(Mesh.PRIMITIVE_LINES)
			mesh.surface_set_color(color)
			mesh.surface_add_vertex(from)
			mesh.surface_add_vertex(to)
			mesh.surface_end()

class Box extends YardDebug:
	func _init(position: Vector3, size: Vector3, color: Color = Color.RED, die: bool = true):
		if Engine.is_editor_hint():
			super(die)
			mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
			mesh.surface_set_color(color)
			mesh.surface_add_vertex(Vector3(-1.0, 1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, 1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(-1.0, -1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, -1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, -1.0, -1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, 1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, 1.0, -1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(-1.0, 1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(-1.0, 1.0, -1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(-1.0, -1.0, 1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(-1.0, -1.0, -1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, -1.0, -1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(-1.0, 1.0, -1.0) * size / 2 + position)
			mesh.surface_add_vertex(Vector3(1.0, 1.0, -1.0) * size / 2 + position)
			mesh.surface_end()

class Sphere extends YardDebug:
	func _init(position: Vector3, radius: float = 1.0, color: Color = Color.RED, die: bool = true):
		if Engine.is_editor_hint():
			super(die)
			var step: int = 15
			var sppi: float = 2 * PI / step
			var axes = [
				[Vector3.UP, Vector3.RIGHT],
				[Vector3.RIGHT, Vector3.FORWARD],
				[Vector3.FORWARD, Vector3.UP]
			]
			mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
			mesh.surface_set_color(color)
			for axis in axes:
				for i in range(step + 1):
					mesh.surface_add_vertex(position + (axis[0] * radius)
						.rotated(axis[1], sppi * (i % step)))
			mesh.surface_end()
