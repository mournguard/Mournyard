class_name YardTileInspectorPlugin extends EditorInspectorPlugin

const SocketsEditor = preload("res://addons/Mournyard/UI/Sockets.tscn")

func _can_handle(object):
	return object is YardTile

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	match name:
		"node":
			var socket_editor = SocketsEditor.instantiate()
			socket_editor.object = object
			add_custom_control(socket_editor)
			return false
	return false
