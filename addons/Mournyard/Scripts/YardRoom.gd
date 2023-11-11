@tool
@icon("res://addons/Mournyard/Icons/room.svg")
class_name YardRoom extends YardItem

func _apply_bounds():
	if not _plan: return
	
	var tile_positions = []
	for c in get_tiles():
		tile_positions.push_back(c.global_position - global_position)

	var clamp_min = Vector3(
		0.0 + YardConsts.TILE_SIZE / 2,
		0.0,
		0.0 + YardConsts.TILE_SIZE / 2
	)
	
	var clamp_max = Vector3(
		_plan.size.x * YardConsts.TILE_SIZE - YardConsts.TILE_SIZE / 2,
		(_plan.size.y - 1) * YardConsts.TILE_SIZE,
		_plan.size.z * YardConsts.TILE_SIZE - YardConsts.TILE_SIZE / 2
	)
	
	clamp_min -= YardMagic.GetMinVector(tile_positions)
	clamp_max -= YardMagic.GetMaxVector(tile_positions)

	position = Vector3(
		clampf(position.x, clamp_min.x, clamp_max.x),
		clampf(position.y, clamp_min.y, clamp_max.y),
		clampf(position.z, clamp_min.z, clamp_max.z)
	)
	
func get_tiles():
	var tiles = []
	for c in get_children():
		if c is YardTile:
			tiles.push_back(c)
	return tiles

func get_size():
	var positions = []
	for c in get_children():
		if not c is YardTile: continue
		positions.push_back(c.position)
	
	var min = YardMagic.GetMinVector(positions)
	var max = YardMagic.GetMaxVector(positions)
	
	return ((max + Vector3.ONE/2*YardConsts.TILE_SIZE) - (min - Vector3.ONE/2*YardConsts.TILE_SIZE))/ YardConsts.TILE_SIZE
