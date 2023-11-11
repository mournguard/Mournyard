## This is bullshit why do I have to do this
class_name YardMagic extends Node

static var _indent = 0

static func Vector3Any(vector: Vector3, cb: Callable) -> bool:
	var x = cb.call(vector.x)
	var y = cb.call(vector.y)
	var z = cb.call(vector.z)
	return x or y or z

static func Empty(node: Node):
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()

static func PositiveRotation(rotation: Vector3):
	var twopi = PI * 2
	while rotation.x < 0:
		rotation.x += twopi
	while rotation.y < 0:
		rotation.y += twopi
	while rotation.z < 0:
		rotation.z += twopi
	
	if is_equal_approx(rotation.x, twopi):
		rotation.x = 0
	if is_equal_approx(rotation.y, twopi):
		rotation.y = 0
	if is_equal_approx(rotation.z, twopi):
		rotation.z = 0
	
	return rotation

static func GetMinVector(vectors: Array) -> Vector3:
	var min = Vector3.INF
	for v in vectors:
		if v.x < min.x:
			min.x = v.x
		if v.y < min.y:
			min.y = v.y
		if v.z < min.z:
			min.z = v.z
	return min

static func GetMaxVector(vectors: Array) -> Vector3:
	var max = -Vector3.INF
	for v in vectors:
		if v.x > max.x:
			max.x = v.x
		if v.y > max.y:
			max.y = v.y
		if v.z > max.z:
			max.z = v.z
	return max

static func DuplicateNode(pnode: Node) -> Node:
	var node = pnode.duplicate()
	Duplicate(node)
	return node

static func DuplicateResource(res: Resource) -> Resource:
	var new = res.duplicate(true)
	Duplicate(new)
	return new

static func Duplicate(thing):
	var properties = thing.get_script().get_script_property_list()
	for p in properties:
		var value = thing.get(p.name)
		var new_value = DuplicateValue(value)
		thing.set(p.name, new_value)

static func DuplicateValue(value):
	match typeof(value):
		TYPE_OBJECT:
			if value is Node:
				return DuplicateNode(value)
			elif value is Resource:
				return DuplicateResource(value)
		TYPE_ARRAY:
			var new_array = []
			for a in value:
				var new_val = DuplicateValue(a)
				new_array.push_back(new_val)
			return new_array
	return value
