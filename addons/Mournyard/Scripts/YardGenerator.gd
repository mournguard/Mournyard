@tool
@icon("res://addons/Mournyard/Icons/yard.svg")
class_name YardGenerator extends GridMap

var _tilled: bool = false
var _tiles: Array[YardTile] = []

## The Plan that describes the Map generated by this Yard.
#@export var plan: YardPlan

## The .tscn Scenes containing the tile meshes. You can add multiple scenes to better organize your tiles. 
## Note that the entire list is reloaded when there's a change so *do not* go crazy.
@export var tile_scenes: Array[PackedScene]:
	set(v): tile_scenes = v; _update_tiles()

@export_category("Debug")
@export_subgroup("Till Data")
@export var till_data: YardTillData

var WFC
var planning_result: Node3D
 
## Refreshes some stuff mostly for when the scene is reopened.
func _ready():
	if not till_data:
		till_data = YardTillData.new()
	_set_tilled(not till_data.data.is_empty())
	
	# Temp stuff
	if not planning_result:
		planning_result = Node3D.new()
	if not planning_result in get_children():
		add_child(planning_result)

## Reloads all the tiles 
func _update_tiles() -> void:
	clear()
	_tiles = []
	mesh_library = MeshLibrary.new()
	for scene in tile_scenes:
		var instance = scene.instantiate()
		for c in instance.get_children():
			if not c is YardTile: continue
			var id = mesh_library.get_last_unused_item_id()
			var tile = c.duplicate()
			_tiles.push_back(tile)
			mesh_library.create_item(id)
			mesh_library.set_item_mesh(id, tile.mesh)
			mesh_library.set_item_name(id, tile.name)
	notify_property_list_changed()

## Delete the current content and wipe all data.
func _clear() -> void:
	clear()
	till_data.data = {}
	_set_tilled(false)
	notify_property_list_changed()

func _draw_WFC() -> void:
	clear()
	#if not WFC or WFC._data.is_empty(): return
	#var size = Vector3(plan.size.x, 1, plan.size.y)
	#for z in size.z:
		#for y in size.y:
			#for x in size.x:
				#if WFC._data[z][y][x].keys().size() > 1: continue
				#var split = WFC._data[z][y][x].keys().front().split('_r')
				#set_cell_item(
					#Vector3(x,y,z) - Vector3(plan.size.x / 2, 0, plan.size.y / 2),
					#_find_tile_index(split[0]),
					#myConsts.ORIENTATIONS[int(split[1])]
				#)

## Triggers the entire generation of the level
func _generate() -> void:
	if not _tilled: return
	
	clear()

func _find_tile_index(tile_name: String) -> int:
	var tname = tile_name.split("_r")[0]
	var i = 0
	for tile in _tiles:
		if tile.name == tname:
			return i
		i += 1
	return -1

## Retrieves new all the available tiles in the folder
func _reload_tiles(path: String) -> void:
	_tiles = []
	var dir = DirAccess.open(path)
	if dir:
		for file in dir.get_files():
			if file.get_extension() == "tscn":
				var tile = load(path + '/' + file).instantiate()
				if tile is YardTile:
					_tiles.append(tile)
	else:
		printerr("An error occurred when trying to access the tiles folder.")

## Sets `_tilled` on the node but also refreshes the inspector to update warnings.
func _set_tilled(tilled: bool) -> void:
	_tilled = tilled
	notify_property_list_changed()

## Returns true if the yard is ready to generate the map
func is_tilled() -> bool:
	return _tilled

## Returns all the tiles available for this Yard
func get_tiles() -> Array[YardTile]:
	return _tiles

## Returns all the tiles of the specified shape
func find_tiles(shape: YardConnection) -> Array[YardTile]:
	return []

## Returns one random tile of the specified shape
func find_random_tile(shape: YardConnection) -> YardTile:
	return find_tiles(shape).pick_random()


func reset_planning() -> void:
	for c in planning_result.get_children():
		planning_result.remove_child(c)
		c.queue_free()

func generate_plan() -> void:
	reset_planning()
	
	# Ok this is the big brain theorizing part
	
	# Step 0:
	# Before attempting generation, a way to represent rooms and find out where their connections are is needed.
	# Probably need to extend myNode so it has an infinite amount of connections.
	# Gods help me
	
	# Step 1:
	# Some rooms are static. So those must be placed first.
	
	# Step 2:
	# While there are still requested positions unfilled
	# For every room
	# For every unfilled neighbor requested position 
	# Pick a room for the room's connection compatible rooms that:
	# Has the right shape (Implicit by being compatible)
	# Is below the maximum deviation
	# Has a connection on every other unfilled neighbors that it would have if it was placed.
	# ↑ This is the very hard part that might always break if not enough rooms are available.
	# I guess to make this work, a series of specific 1x1x1 rooms would be a minimum requirement for any roomset.
	
	# Step 3: 
	# Optional; If the plan is a Field:
	# Propagate all the WFC contraints from the above result
	# Generate inside the boundaries using tiles directly.
	
	# This is it except the previous two steps will require 1000 lines each

## Takes a side int and rotates it by rot int
static func RotateSide(side: int, rot: int) -> int:
	var rotation_map = [2,5,3,4]
	return side if side in [0,1] else rotation_map[(rotation_map.find(side) + rot) % 4]

## Takes a side int and returns the opposite
static func OppositeSide(side: int) -> int:
	return [1,0,3,2,5,4][side]

## Takes a side int and converts it to a string, mostly for debug purposes.
static func SideToString(side: int) -> String:
	match side:
		0: return "top"
		1: return "bottom"
		2: return "left"
		3: return "right"
		4: return "front"
		5: return "back"
	return "unknown"
