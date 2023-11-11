@tool
class_name YardNode extends Resource

@export var connections = []
@export var rotation: int = 0

static func FromDirections(directions: Array[Vector3] = []):
	var node = YardNode.new()
	node.connections.clear()
	for direction in directions:
		var connection = YardConnection.FromDirection(direction)
		connection.resource_local_to_scene = true
		node.connections.push_back(connection)
	return node

func update_rotation(rot: int):
	for connection in connections:
		if connection.direction in YardConsts.VERTICAL_DIRECTIONS: continue
		connection.direction = round(Vector3(connection.direction).rotated(Vector3.UP, PI/2.0 * (rot - rotation)))
	rotation = rot

func clear_connection_sockets():
	for c in connections:
		c.clear_sockets()

func set_connection_sockets(sockets: Array):
	if not sockets.size() == connections.size():
		printerr("YardNode: Trying to directly set connection sockets with a mismatching connection<->socket size.")
		
	for index in sockets.size():
		connections[index].sockets = sockets[index].duplicate()

func get_connections_by_direction(direction: Vector3):
	return connections.filter(func(c): return c.direction == direction)

func get_socket_count():
	return connections.size() * YardConsts.NODE_CONNECTION_SIZE * YardConsts.NODE_CONNECTION_SIZE

func toggle_socket_from_id(id: int):
	var size = (YardConsts.NODE_CONNECTION_SIZE * YardConsts.NODE_CONNECTION_SIZE)
	get_connection_from_id(id).toggle_socket(id % size)
	#print('-----')
	#for c in connections:
	#	print(c.sockets)

func get_connection_from_id(id: int):
	var size = (YardConsts.NODE_CONNECTION_SIZE * YardConsts.NODE_CONNECTION_SIZE)
	return connections[id / size]

func get_socket_from_id(id: int):
	var size = (YardConsts.NODE_CONNECTION_SIZE * YardConsts.NODE_CONNECTION_SIZE)
	return get_connection_from_id(id).sockets[id % size]
