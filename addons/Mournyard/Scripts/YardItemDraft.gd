@tool
class_name YardItemDraft extends YardItem

@export_subgroup("Color Override")
@export var color_override: Color = Color.DIM_GRAY

func _get_color() -> Color:
	var color = color_override
	color.a = 0.25
	return color
