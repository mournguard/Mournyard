@tool
class_name YardConnection extends Resource

var value: String = "":
	get: return _serialize()
@export var position: Vector3
@export var direction: Vector3
@export var gate: bool = false
@export var sockets = []

static func FromDirection(direction: Vector3) -> YardConnection:
	var connection = YardConnection.new()
	connection.direction = round(direction)
	connection.sockets.resize(YardConsts.NODE_CONNECTION_SIZE * YardConsts.NODE_CONNECTION_SIZE)
	return connection

func _serialize() -> String:
	var size = YardConsts.NODE_CONNECTION_SIZE
	
	if not size: return ""
	
	var side = ""
	
	side += "v" if is_vertical() else ""

	for v in sockets:
		side += "1" if v else "0"
	
	# Figure out if this side is symmetrical
	var mid = size / 2
	var s = true
	for y in size:
		for x in mid:
			var a = sockets[x + y * size]
			var b = sockets[(size - 1 - x) + y * size]
			if a != b:
				s = false
	if s: side += "s"
	
	return side

func clear_sockets():
	sockets.clear()
	sockets.resize(YardConsts.NODE_CONNECTION_SIZE * YardConsts.NODE_CONNECTION_SIZE)

func flipped() -> YardConnection:
	var copy = YardMagic.DuplicateResource(self)

	# Vertical cannot be flipped, flipped symmetrical is by definition the same
	if is_vertical() or is_symmetrical():
		return copy
	
	var size = YardConsts.NODE_CONNECTION_SIZE
	copy.sockets = []
	
	var tmp_sockets = sockets
	while tmp_sockets.size():
		var row = tmp_sockets.slice(0,3)
		row.reverse()
		copy.sockets.append_array(row)
		tmp_sockets = tmp_sockets.slice(3)
	return copy

func is_vertical() -> bool:
	return direction in YardConsts.VERTICAL_DIRECTIONS

func is_symmetrical() -> bool:
	return value.ends_with("s")

func toggle_socket(id: int) -> void:
	if id >= sockets.size(): return
	sockets[id] = !sockets[id]
	value = _serialize()

func _to_string():
	return "Sockets: " + str(sockets) + ', Direction: ' + str(direction)
