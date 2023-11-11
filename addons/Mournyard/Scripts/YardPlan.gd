@tool
@icon("res://addons/Mournyard/Icons/plan.svg")
class_name YardPlan extends Node
## YardPlans are the way Maps are described
##
## YardPlans are a container for other nodes and describe how a Map should be generated conceptually.

var _collision_debug_color: Color = Color.hex(0xff000088)

signal content_changed(callback: Callable)

@export_dir var tiles_path:
	set(v): tiles_path = v; _get_tiles();
var tiles: Array[PackedScene] = []
@export_dir var rooms_path:
	set(v): rooms_path = v; _get_rooms();
var rooms: Array[PackedScene] = []

@export_category("Generation Settings")
enum GENERATION_TYPE {FIELD, DUNGEON}
@export var type: GENERATION_TYPE = GENERATION_TYPE.DUNGEON
@export var size: Vector3 = Vector3(50, 5, 50):
	set(v): size = v.round(); _update_astar();

@export_category("Display")
@export var planning_area: bool = false:
	set(v): planning_area = v; _on_content_changed();
@export var content_collisions: bool = true:
	set(v): content_collisions = v; _on_content_changed();

@export_category("Debug")
@export_subgroup("Till Data")
@export var till_data: YardTillData

var _debug_collisions_container: Node3D
var _debug_display_container: Node3D
var _astar: AStarGrid3D

func _ready():
	_init_debug()
	_update_astar()
	content_changed.connect(_on_content_changed)
	child_order_changed.connect(_on_content_changed)

func _init_debug():
	if not _debug_collisions_container:
		_debug_collisions_container = Node3D.new()
		add_child(_debug_collisions_container)
	
	if not _debug_display_container:
		_debug_display_container = Node3D.new()
		add_child(_debug_display_container)

func _get_tiles():
	if not tiles_path:
		tiles = []
		return
	
	var tile_list: Array[PackedScene] = []
	var list := _get_files_in_dir(tiles_path)
	for tile in list:
		var scene = load(tile)
		var tile_instance = scene.instantiate()
		if tile_instance is YardTile:
			tile_list.append(scene)
	tiles = tile_list
	notify_property_list_changed()

func _get_rooms():
	if not rooms_path:
		rooms = []
		return
		
	var room_list: Array[PackedScene] = []
	var list := _get_files_in_dir(rooms_path)
	for room in list:
		var scene = load(room)
		var room_instance = scene.instantiate()
		if room_instance is YardRoom:
			room_list.append(scene)
	rooms = room_list
	notify_property_list_changed()

func _get_files_in_dir(path: String) -> Array:
	var list := []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var path_name = dir.get_next()
		while path_name != "":
			if dir.current_is_dir():
				list.append_array(_get_files_in_dir(path + '/' + path_name))
			else:
				list.append(path + '/' + path_name)
			path_name = dir.get_next()
	return list

func _on_content_changed(callback: Callable = func():pass):
	if not is_inside_tree() or not _debug_collisions_container or not _debug_display_container:
		return

	YardMagic.Empty(_debug_collisions_container)
	YardMagic.Empty(_debug_display_container)
	
	_scan_and_display()
	
	if planning_area:
		var color = Color.BLUE
		color.a = 0.05
		
		var box_size = size * YardConsts.TILE_SIZE
		box_size.y = 0.5
		
		_debug_display_container.add_child(YardDebug.Box.new(box_size / 2, box_size, color, false))
	
	callback.call()

func _scan_and_display():
	_astar.clear_meta_keys(['used', 'collision'])
	for c in get_children():
		if c is YardTile:
			_scan_tile(c)
		elif c is YardRoom:
			_scan_room(c)
		elif c is YardPath:
			_scan_path(c)

func _scan_tile(tile: YardTile):
	var point = tile.get_grid_position()
	var used = _astar.get_point_meta(point, 'used')
	if used and content_collisions:
		_debug_collisions_container.add_child(YardDebug.Box.new(point * YardConsts.TILE_SIZE + Vector3.ONE * YardConsts.TILE_SIZE / 2, Vector3.ONE * YardConsts.TILE_SIZE, _collision_debug_color, false))
	_astar.set_point_meta(point, 'used', true)

func _scan_room(room: YardRoom):
	for c in room.get_tiles():
		_scan_tile(c)

func _scan_path(path: YardPath):
	pass

## Generate an AStar3D grid for the plan
func _update_astar():
	if not _astar:
		_astar = AStarGrid3D.new()
	_astar.size = size
	_on_content_changed()

## Get all Paths in the Plan
func _get_paths() -> Array[YardPath]:
	var paths: Array[YardPath] = []
	for c in get_children():
		if c is YardPath:
			paths.append(c)
	return paths

## Override the setter to prevent accidental user modifications
func _set(property, value):
	match property:
		"position":
			printerr("You should not modify the `position` of a `myPlan` node, instead, edit its contents.")
			return true
		"rotation":
			printerr("You should not modify the `rotation` of a `myPlan` node, instead, edit its contents.")
			return true
		"scale":
			printerr("You should not modify the `scale` of a `myPlan` node, instead, edit its contents.")
			return true
	return false

func get_astar() -> AStar3D:
	return _astar

func is_editing() -> bool:
	if EditorInterface.get_selection().get_selected_nodes().has(self):
		return true
	
	for c in get_children():
		if EditorInterface.get_selection().get_selected_nodes().has(c):
			return true
	
	return false
