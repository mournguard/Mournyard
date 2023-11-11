# TODO: Actual Settings
class_name YardConsts

const TILE_SIZE: int = 4
const TILE_SOCKET_MOUSE_THRESHOLD = 100.0
const NODE_CONNECTION_SIZE: int = 3
const HANDLE_SELECT_DISTANCE: float = 50.0
const ARROW_SELECT_DISTANCE: float = 100.0
const ASTAR_WEIGHT: float = 10.0

## This is extremely dumb but hey
const DIRECTIONS: Array[Vector3] = [
	Vector3.UP,
	Vector3.DOWN,
	Vector3.RIGHT,
	Vector3.LEFT,
	Vector3.BACK,
	Vector3.FORWARD,
]
const OPPOSITE_DIRECTIONS: Array[Vector3] = [
	Vector3.UP,
	Vector3.DOWN,
	Vector3.LEFT,
	Vector3.RIGHT,
	Vector3.FORWARD,
	Vector3.BACK,
]
const VERTICAL_DIRECTIONS: Array[Vector3] = [
	Vector3.UP,
	Vector3.DOWN,
]
const HORIZONTAL_DIRECTIONS: Array[Vector3] = [
	Vector3.RIGHT,
	Vector3.LEFT,
	Vector3.BACK,
	Vector3.FORWARD,
]

const ORIENTATIONS = [0,16,10,22] # https://github.com/godotengine/godot/blob/42425baa59956dc9d1e22341fe5e5d7f8fad5067/modules/gridmap/grid_map.cpp#L437

## Presets
const SOCKET_PRESETS = {
	"Bottom_Floor": [
		[false, false, false, false, false, false, false, false, false],
		[true, true, true, true, true, true, true, true, true],
		[false, false, false, false, false, false, true, true, true],
		[false, false, false, false, false, false, true, true, true],
		[false, false, false, false, false, false, true, true, true],
		[false, false, false, false, false, false, true, true, true],
	],
	"Bottom_Wall": [
		[false, false, false, false, false, false, false, false, false],
		[false, false, false, true, true, true, true, true, true],
		[false, false, false, true, true, false, false, true, true],
		[false, false, false, false, true, true, true, true, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, false, false, false, true, true, true],
	],
	"Bottom_Wall Corner Out": [
		[false, false, false, false, false, false, false, false, false],
		[false, true, true, true, true, true, true, true, true],
		[false, false, false, false, false, false, true, true, true],
		[false, false, false, false, true, true, true, true, false],
		[false, false, false, true, true, false, false, true, true],
		[false, false, false, false, false, false, true, true, true],
	],
	"Bottom_Wall Corner In": [
		[false, false, false, false, false, false, false, false, false],
		[false, false, false, false, true, true, false, true, true],
		[false, false, false, true, true, false, false, true, true],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, false, true, true, true, true, false],
	],
	"Bottom_Corridor Entrance": [
		[false, false, false, false, false, false, false, false, false],
		[false, true, false, true, true, true, true, true, true],
		[false, false, false, true, true, false, false, true, true],
		[false, false, false, false, true, true, true, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, false, false, false, true, true, true],
	],
	"Bottom_Corridor Straight": [
		[false, false, false, false, false, false, false, false, false],
		[false, true, false, false, true, false, false, true, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
	],
	"Bottom_Corridor Cross": [
		[false, false, false, false, false, false, false, false, false],
		[false, true, false, true, true, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
	],
	"Bottom_Corridor T": [
		[false, false, false, false, false, false, false, false, false],
		[false, false, false, true, true, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, true, false, true, false, true, false],
	],
	"Bottom_Corridor Corner": [
		[false, false, false, false, false, false, false, false, false],
		[false, false, false, false, true, true, false, true, false],
		[false, false, false, true, false, true, false, true, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, true, true, true, false, false, false],
		[false, false, false, true, false, true, false, true, false],
	],
}
