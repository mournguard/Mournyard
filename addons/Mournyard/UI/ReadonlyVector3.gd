@tool
extends Control

@export var property: String = "Property":
	set(v): property = v; %property.text = v.to_pascal_case();

@export var text: String = "This property is readonly.":
	set(v): text = v; %text.text = v;

@export var value: Vector3 = Vector3.ZERO:
	set(v): value = v; %x.text = str(v.x); %y.text = str(v.y); %z.text = str(v.z);

