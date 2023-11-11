class_name YardItemDraftInspectorPlugin extends EditorInspectorPlugin

const ColorOverride = preload("res://addons/Mournyard/UI/ColorOverride.tscn")

func _can_handle(object):
	return object is YardItemDraft

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if not object: return
	if name == "color_override":
		var override = ColorOverride.instantiate()
		override.object = object
		add_custom_control(override)
		return true
	return false
