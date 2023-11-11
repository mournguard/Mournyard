@tool
extends Control

@export var object: Node

@export var property: String = "Property":
	set(v): property = v; %property.text = v.to_pascal_case();

@export var text: String = "This is the property description.":
	set(v): text = v; %text.text = v;

@export var value: bool = false:
	set(v): value = v; %value.button_pressed = v;

func _on_value_pressed():
	if not object or not property: return
	object.set(property, %value.button_pressed)
