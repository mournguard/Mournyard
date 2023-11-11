@tool
extends EditorPlugin

#const EditorScreen = preload("res://addons/Mournyard/Screen/MYardScreen.tscn")
#var editor_screen

const YardSocketGizmoPlugin = preload("res://addons/Mournyard/Gizmos/YardSocketsGizmo.gd")
var _yard_socket_gizmo_plugin: EditorNode3DGizmoPlugin

const YardPlanInspectorPlugin = preload("res://addons/Mournyard/Inspectors/YardPlanInspectorPlugin.gd")
var _yard_plan_inspector_plugin: EditorInspectorPlugin

const YardItemInspectorPlugin = preload("res://addons/Mournyard/Inspectors/YardItemInspectorPlugin.gd")
var _yard_item_inspector_plugin: EditorInspectorPlugin

const YardItemDraftInspectorPlugin = preload("res://addons/Mournyard/Inspectors/YardItemDraftInspectorPlugin.gd")
var _yard_item_draft_inspector_plugin: EditorInspectorPlugin

const YardTileInspectorPlugin = preload("res://addons/Mournyard/Inspectors/YardTileInspectorPlugin.gd")
var _yard_tile_inspector_plugin: EditorInspectorPlugin

var _camera: Camera3D
var _mouse_position: Vector2

func _enter_tree():
	#editor_screen = EditorScreen.instantiate()
	#EditorInterface.get_editor_main_screen().add_child(editor_screen)
	#EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)
	_add_inspector_plugins()
	_add_custom_types()
	_make_visible(false)

func _exit_tree():
	#if editor_screen:
	#	editor_screen.queue_free()

	_remove_inspector_plugins()
	_remove_custom_types()

# Required for _forward_3d_gui_input to work ???
func _handles(_object):
	return true

func _process(_delta):	
	if not _camera or _mouse_position.is_equal_approx(Vector2.ZERO):
		return
		
	var tile = null
	for n in EditorInterface.get_selection().get_selected_nodes():
		if n is YardTile and n.editing:
			tile = n
	
	if tile:
		_update_tile_handles(tile)
		_update_tile_arrows(tile)
		tile.update_gizmos()

func _update_tile_handles(tile: YardTile):
	_yard_socket_gizmo_plugin.handle_alphas.resize(tile.node.get_socket_count())
	if tile.just_editing:
		for i in tile.node.get_socket_count():
			_yard_socket_gizmo_plugin.handle_alphas[i] = 1
	else:
		for i in tile.node.get_socket_count():
			var connection = tile.node.get_connection_from_id(i)
			var index = tile.node.connections.find(connection)
			var position = tile.position + _yard_socket_gizmo_plugin.id_to_position(i, connection.direction, index)
			var ray = _camera.project_position(_mouse_position, (position - _camera.position).length())
			var alpha = 1 - clamp(ray.distance_squared_to(position) / YardConsts.TILE_SOCKET_MOUSE_THRESHOLD, 0, 1)
			if alpha > 0.5:
				_yard_socket_gizmo_plugin.handle_alphas[i] = alpha

func _update_tile_arrows(tile: YardTile):
	var connections: Array[YardConnection] = []
	for c in tile.node.connections:
		if c.is_vertical(): continue
		
		var position = _yard_socket_gizmo_plugin._get_arrow_position(c.direction)
		var dist = _camera.unproject_position(tile.position + position).distance_to(_mouse_position)
		if dist < YardConsts.ARROW_SELECT_DISTANCE:
			if not _yard_socket_gizmo_plugin.hovered_arrows.has(c):
				_yard_socket_gizmo_plugin.hovered_arrows.push_back(c)
		else:
			_yard_socket_gizmo_plugin.hovered_arrows.erase(c)

func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent):
	if not event is InputEventMouseMotion: return EditorPlugin.AFTER_GUI_INPUT_PASS
	
	_camera = viewport_camera
	_mouse_position = event.position
	
func _make_visible(visible):
	#editor_screen.visible = visible
	pass

func _has_main_screen():
	return false
	
func _get_plugin_name():
	return "Mournyard"

#func _on_selection_changed():
#	var nodes = EditorInterface.get_selection().get_selected_nodes()
#	if not nodes.size() or nodes.size() > 1: return

func _add_custom_types():
	add_custom_type("YardPlan", "Node3D", preload("Scripts/YardPlan.gd"), preload("Icons/plan.svg"))
	add_custom_type("YardTile", "MeshInstance3D", preload("Scripts/YardTile.gd"), preload("Icons/tile.svg"))
	add_custom_type("YardRoom", "Node3D", preload("Scripts/YardRoom.gd"), preload("Icons/room.svg"))
	add_custom_type("YardGate", "Node3D", preload("Scripts/YardGate.gd"), preload("Icons/gate.svg"))
	add_custom_type("YardPath", "Path3D", preload("Scripts/YardPath.gd"), preload("Icons/plan_path.svg"))
	
	#add_custom_type("Mournyard", "GridMap", preload("Nodes/Mournyard.gd"), preload("Icons/map.svg"))
	#add_custom_type("YardRoom", "Node3D", preload("Nodes/YardRoom.gd"), preload("Icons/room.svg"))
	#add_custom_type("YardMap", "Node3D", preload("Nodes/YardMap.gd"), preload("Icons/map.svg"))
	#add_custom_type("YardPlanGate", "Node3D", preload("Nodes/YardPlanGate.gd"), preload("Icons/plan.svg"))
	
func _remove_custom_types():
	remove_custom_type("YardPlan")
	remove_custom_type("YardTile")
	remove_custom_type("YardRoom")
	remove_custom_type("YardGate")
	remove_custom_type("YardPath")
	
	#remove_custom_type("YardPlanPath")
	#remove_custom_type("Mournyard")
	#remove_custom_type("MYardMap")
	#remove_custom_type("MYardGenerator")
	#remove_custom_type("MYardPlan")

func _add_inspector_plugins():
	_yard_socket_gizmo_plugin = YardSocketGizmoPlugin.new()
	add_node_3d_gizmo_plugin(_yard_socket_gizmo_plugin)
	
	_yard_plan_inspector_plugin = YardPlanInspectorPlugin.new()
	add_inspector_plugin(_yard_plan_inspector_plugin)
	
	_yard_item_inspector_plugin = YardItemInspectorPlugin.new()
	add_inspector_plugin(_yard_item_inspector_plugin)
	
	_yard_item_draft_inspector_plugin = YardItemDraftInspectorPlugin.new()
	add_inspector_plugin(_yard_item_draft_inspector_plugin)
	
	_yard_tile_inspector_plugin = YardTileInspectorPlugin.new()
	add_inspector_plugin(_yard_tile_inspector_plugin)
	
	#_my_tile_inspector_plugin = myTileInspectorPlugin.new()
	#add_inspector_plugin(_my_tile_inspector_plugin)
	#
	#_mournyard_inspector_plugin = MournyardInspectorPlugin.new()
	#add_inspector_plugin(_mournyard_inspector_plugin)
	
	#_myard_plan_inspector_plugin = MYardPlanInspectorPlugin.new()
	#add_inspector_plugin(_myard_plan_inspector_plugin)

func _remove_inspector_plugins():
	remove_node_3d_gizmo_plugin(_yard_socket_gizmo_plugin)
	remove_inspector_plugin(_yard_plan_inspector_plugin)
	remove_inspector_plugin(_yard_item_inspector_plugin)
	remove_inspector_plugin(_yard_item_draft_inspector_plugin)
	remove_inspector_plugin(_yard_tile_inspector_plugin)
	#remove_inspector_plugin(_my_tile_inspector_plugin)
	#remove_inspector_plugin(_mournyard_inspector_plugin)
	#remove_inspector_plugin(_myard_plan_inspector_plugin)

# Currently unsure about my original intent of making the procedural generation system two-tiered.

# I had planned to make it so that it would lay out rooms, and that each rooms would be composed of tiles.

# But by their nature of being usable as POIs, room sizes must be entirely customizable.

# This leads me to inevitably think about having rooms that are only 1 tile size

# And then this makes me wonder if I even need the two tiers at all

# Trying to imagine a workflow/process for only one tier of nodes :
# You design rooms/tiles whatever, let's call them parts. 
# Some parts are 1x1x1, some parts aren't. 
# As they need to all hold connection information, this means that each possible "side" of a part holds 
# as many connections as it's size. Previously, tiles had 3x3 connections per side. Now, they have XxYxZ.
# This is a lot more complex I guess but would it even be usable
# If you design a part that's 10x10x5, some sides have up to 100 connections ??????
# I guess connections would still occur only on some fixed world-size grid.
# But I'd like to be able to generate corridors that are reliably tight. So I guess it could be at max like
# what, 3x3x3 ?
# The previous actual tile size was 4. Maybe that's enough. Nothing prevents parts to actually be smaller,
# it's just that parrallel parts will need that min in spacing.

# Now, previously, the generation used Shapes to compare tile sides.
# If it now needs to have the ability to place multiple nodes on each side, shapes can't really be used in the same way.
# It still needs to use the same system of being able to compare sides, but now, some parts of that side might be blocked off already.
# It's relatively simple to retrieve neighbor rooms and check if a room can even request a certain position,
# But when you need to start taking into account rotations, flips...
# At this point I'm thinking that going a more classic route instead of WFC wouldn't be faster and simpler.

# Say a room has a side that's 10x6
# On this side, another room is place at 1,0, taking 2x2 space.
# This means the original room's side now looks like
# 0000000000
# 0000000000
# 0000000000
# 0000000000
# 0110000000
# 0110000000
# And then also including whatever blocked sockets it itself has.
# If now a room tries to place itself, it needs to be able to consider every possible position it could do so.
# This would mean taking every kind of possible subset of this face and compare it to every possible variation of the room
# This feels fucking intense.

# If I keep the two-tiered system the rooms could be entirely *not* nodes. And thus only carry tiles in an intent to stamp them.
# After injecting the room's tiles in the map, the rest of the process could continue relatively the same way as before, using WFC.
# Although at this point, adding new rooms into the system is also a funky little problem.
# I could just keep everything extra tightly attached to the grid but that's dumb.

# Say a room is 5x5x2
# It is placed on the grid, so its 50 tiles are essentially unpacked.
# Great, now we need to place another one. It doesn't matter where it's placed, each of it's tiles just need to validate their placement
# Entirely on their own, so that's simple.
# Problem comes again when we want to consider rotation/flipping the room.
# This could all be brute-forced, I guess ?
# Every time the system wants to add a room, it could just pick one according to the plan's max deviation settings
# Try to place it on the requested node in any way it can
# It that doesn't work, remove it from the possible rooms, and pick another.

# The problem with that is that unlike the WFC setup, that can't be baked, so it would be very slow.

# The more I think about it the more I think it's unrealistic to expect me to code such a customizable system where all rooms aren't the same size lol

# The problems above are why I wanted to make rooms nodes in the same way as tiles, but that's exactly what would make them all the same size.

# One important question is, do I want rooms to only carry tile information, or do I want them to have explicit connections
# Because if they have explicit connections it might involved a lot more tooling work, but might make the generation much better.


# Say a room is 10x10x3 (tiles)
# With a tile size of 4 this means the room is 40x40x12
# Only the 6th, bottom tile is tagged as a connection, this means that when placing rooms, only the 
# 11,12,13 (x) 1,2,3 (y) sockets are considered.
# This can be represented using the Shape feature already semi-implemented.
# It could also be possible to pre-bake all room connections, although collisions would still need to be checked during generation
# This could still allow to pick rooms from a pool of all room with a low-enough divergeance.
# Requirements to make this work:
# 	Keep the two-tiered system
# 	Add a way to tag tiles as exits
# This should work, but now, tagging is unresolved.

# I feel like this should involve some high abstraction levels before actually going into the generation logic 
# but I'm unsure as too how much I should abstract it and how the classes should be setup.

# Tile :
# Tilling data includes every possible connection to every other available tile
# Has sockets gizmos
# Is a MeshInstance3D so be used with Godot's Gridmap
# Is *always* 4x4x4
# Each side can be tagged as an exit side (It won't make sense if those side aren't used on the boundary of a room but it won't cause any problem either)

# Room :
# Tilling data includes every possible room that has a corresponding side
# Composed of tiles
# Has no gizmo, but can selectively display the gizmos of every exit side
# Could itself maybe be a GridMap, if the tools are considered worth using.
# After the updates in Godot 4.2.dev5, the gridmap is considerable less annoying to use.
# The main problem with using it is that it's populated by grabbing meshes directly, so we lose tile information
# Either not use it or have the rooms store their internal, full version of each tile it's composed from.
# That would require having the ability to into a "tile_added" even or something from the gridmap, 
# or rebuilding the list every time the map changes.
# It would get confusing really quickly I think.
# Room = Not a Gridmap
# The usage of gridmap in the yard is mostly to use it's performance improvements anyway, not so much for the tool.
# eeeeeeeeeeeeeeeeh it's actually possible to keep a mapping from tile -> meshlibrary tile
# I still don't think it should be used and at this point this is outside the scope of this plugin;
# a good external asset placer will be much better than anything else I could come up with anyway

# Setting up all the required classes without inevitably having to duplicate code is complicated without the possibility of using interfaces 
# Required classes:
# ✔️ High level node class to hold anything related to the Tilling process that isn't too specific.
# ✔️ Tile class
# Room class
# Generic WFC implementation working on the structure of the high-level tilling node
# Mouryard with the ability to read the WFC data and populate it's gridmap

# All this typing and planning and I forgot to think about paths
# Will probably just ignore them for now.

# Next:
# Try to Till Rooms
# Consider resizing paths. I'm done considering I won't do it

# Missing Plan Tools:
# Tags on paths
# End of map tag (for Fields)

# How in the high holy fuck will I figure out the orientation of chasms.

# Should really just use straight rooms and tiles in the plans
