@tool
extends MarginContainer

@export var object: Node

const PresetIconTop = preload("res://addons/Mournyard/Images/sockets_top.png")
const PresetIconMiddle = preload("res://addons/Mournyard/Images/sockets_middle.png")
const PresetIconBottom = preload("res://addons/Mournyard/Images/sockets_bottom.png")

func _ready():
	_sync()
	_load_presets()
	%Presets.get_popup().id_pressed.connect(_on_popup_pressed)

func _sync():
	%Button.button_pressed = object.editing

func _load_presets():
	var menu = %Presets.get_popup()
	menu.clear()
	for preset in YardConsts.SOCKET_PRESETS:
		menu.add_icon_item(PresetIconBottom, preset)

func _on_popup_pressed(id: int):
	var sockets = YardConsts.SOCKET_PRESETS[%Presets.get_popup().get_item_text(id)]
	object.node.set_connection_sockets(sockets)
	object.editing = true
	_on_button_toggled(true)
	object.update_gizmos()

func _on_button_toggled(toggled_on):
	object.editing = toggled_on
	object.update_gizmos()

func _on_clear_pressed():
	object.node.clear_connection_sockets()
	object.editing = true
	_on_button_toggled(true)
	object.update_gizmos()
