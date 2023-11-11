class_name YardItemInspectorPlugin extends EditorInspectorPlugin

const EditorMessage = preload("res://addons/Mournyard/UI/EditorMessage.tscn")
const DetailedBooleanProperty = preload("res://addons/Mournyard/UI/DetailedBooleanProperty.tscn")
const TagList = preload("res://addons/Mournyard/UI/TagList.tscn")

func _can_handle(object):
	return object is YardItem

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if not object: return
	if name == "tags":
		var taglist = TagList.instantiate()
		taglist.object = object
		add_custom_control(taglist)
		return true
	return false
