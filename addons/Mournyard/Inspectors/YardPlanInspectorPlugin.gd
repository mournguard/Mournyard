class_name YardPlanInspectorPlugin extends EditorInspectorPlugin

const EditorWarning = preload("res://addons/Mournyard/UI/EditorWarning.tscn")
const EditorMessage = preload("res://addons/Mournyard/UI/EditorMessage.tscn")
const PlanControls = preload("res://addons/Mournyard/UI/PlanControls.tscn")
const TillDataView = preload("res://addons/Mournyard/UI/TillDataView.tscn")

func _can_handle(object):
	return object is YardPlan

func _parse_begin(object):
	if true or not object.is_tilled():
		var warning = EditorWarning.instantiate()
		warning.text = "This Plan is not Tilled!\n\nThis means the plan has no knowledge of how Tiles and Rooms can be arranged together. When making changes, you need to press the \"Till\" button below, or call the `till` method." 
		add_custom_control(warning)
	
	var controls = PlanControls.instantiate()
	controls.plan = object
	add_custom_control(controls)

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if name == "tiles_path":
		var msg = EditorMessage.instantiate()
		msg.text = "Found %s tiles." % object.tiles.size()
		add_custom_control(msg)
	if name == "rooms_path":
		var msg = EditorMessage.instantiate()
		msg.text = "Found %s rooms." % object.rooms.size()
		add_custom_control(msg)
	if name == "till_data": 
		var view = TillDataView.instantiate()
		var json = JSON.new()
		view.text = json.stringify(object.till_data.data, "\t") if object.till_data else ""
		add_custom_control(view)
		return true
	return false
