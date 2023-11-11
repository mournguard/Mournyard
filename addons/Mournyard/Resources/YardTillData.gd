class_name YardTillData extends Resource

@export var data = {}

## Runs the algorithm that pre-bakes every possible way tiles can connect together
func till(tiles: Array[PackedScene]) -> void:
	if not tiles.size():
		printerr("Trying to Till without Tiles.")
		return
	
	# Generate the tile list
	var d = {}
	var known_connections = []
	
	# For all tiles, find all valid neighbors for every side.
	for tile in tiles:
		# Well maybe the issue wasn't duplication then
		var t = tile.instantiate()
		#if t.name != "wall_01": continue
		for rot in 4:
			# Changing the tile rotation will change the rotation of all connections
			t.rotation = Vector3(0, PI/2 * rot, 0)
			var data = {}
			data['weight'] = t.weight
			data['connections'] = []
			for connection in t.node.connections:
				var opposite_side = YardConsts.OPPOSITE_DIRECTIONS[
					YardConsts.DIRECTIONS.find(connection.direction)
				]
				# Register known asymmetrical connections
				if not connection.is_vertical() and not connection.is_symmetrical() and not known_connections.has(connection.flipped().value):
					known_connections.push_back(connection.value)
				var n_data = {}
				n_data['direction'] = str(connection.direction)
				n_data['valid'] = []
				n_data['value'] = connection.value
				if connection.direction in YardConsts.HORIZONTAL_DIRECTIONS:
					for neighbor in tiles:
						var n = YardMagic.DuplicateNode(neighbor.instantiate())
						for rotn in 4:
							n.rotation = Vector3(0, PI/2 * rotn, 0)
							for nc in n.node.get_connections_by_direction(opposite_side):
								if nc.value == connection.flipped().value:
									n_data['valid'].push_back(n.name + "_r" + str(rotn))
				data['connections'].push_back(n_data)
			d[t.name + "_r" + str(rot)] = data
	data = d
