# TODO: Capture node rotation to automatically update the internal R
# TODO: Add custom display to the sockets prop:
#	- Add a toggle button to enter edit mode to prevent accidental edits
#	- Add socket presets
#	- Add a section to handle tags for every socket
#	- Add a section to handle gate-ness for every socket
#	- Hide internal node
#	- Hide R once the above is done
# TODO: Update Tiles Gizmo
#	- Add arrows to display gates
#	- Update line colors only depending on selection status

@tool
@icon("res://addons/Mournyard/Icons/tile.svg")
class_name YardTile extends YardItem

@export_range(0,1,0.01) var weight: float = 0.5

var neighbors: Array[YardTile]
@export var node: YardNode

var editing: bool = false:
	set(v): editing = v; just_editing = v
var just_editing: bool = false

func _ready() -> void:
	super()
	
	_init_node()
	if not neighbors: _init_neighbors()
	
	if Engine.is_editor_hint():
		EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)

func _process(delta):
	super(delta)

	if editing: 
		update_gizmos()
		
# The best 3 lines of gdscript very understandable very good
	do() if just_editing else dont()
func do(): (func(): just_editing = false).call_deferred()
func dont(): return null

func _init_node() -> void:
	if node: 
		node = YardMagic.DuplicateResource(node)
	else:
		node = YardNode.FromDirections(YardConsts.DIRECTIONS)

func _init_neighbors() -> void:
	neighbors = []
	neighbors.resize(6)

func _on_selection_changed() -> void:
	if not EditorInterface.get_selection().get_selected_nodes().has(self):
		editing = false
		update_gizmos()

func _update_position():
	var offset = Vector3(1,0,1) * (Vector3.ONE * YardConsts.TILE_SIZE / 2)
	position = (position + offset).snapped(Vector3.ONE * YardConsts.TILE_SIZE) - offset
	_apply_bounds()

func _update_node_rotation() -> void:
	if not node: _init_node()
	node.update_rotation(rotation_index)

func _set(property, value):
	if property == "rotation":
		rotation = round(YardMagic.PositiveRotation(value) / (PI/2)) * PI/2
		_prev_rotation = rotation
		_update_node_rotation()
		return true
	return false

func get_grid_position():
	return (global_position - Vector3(1,0,1) * YardConsts.TILE_SIZE / 2) / YardConsts.TILE_SIZE

func get_filename() -> String:
	return scene_file_path.split("/").slice(-1)[0].left(-5)

func get_connection(direction: Vector3) -> YardConnection:
	direction = direction.normalized()
	for connection in node.connections:
		if connection.direction == direction:
			return connection
	return null
