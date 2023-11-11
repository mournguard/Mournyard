@tool
extends MarginContainer

@export var object: YardItem

func _ready():
	%ColorPicker.color = object.color_override
	%ColorPicker.color_changed.connect(_on_color_changed)

func _on_color_changed(color: Color):
	object.color_override = color
	object._color_changed(color)
