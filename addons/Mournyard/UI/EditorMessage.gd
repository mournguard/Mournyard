@tool
extends Node

@export var text: String = "":
	set(v): text = v; %Label.text = v
