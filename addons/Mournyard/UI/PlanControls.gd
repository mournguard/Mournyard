@tool
extends Node

@export var plan: YardPlan

func _on_till_pressed():
	plan.till_data = YardTillData.new()
	plan.till_data.till(plan.tiles)
	print(plan.till_data.data)

func _on_reset_pressed():
	if not plan.plan or not plan.till_data or plan.till_data.data.is_empty(): return
	
	#var size = Vector3(plan.plan.size.x, 1, plan.plan.size.y)
	#plan.WFC = myWFC.new(size, plan.till_data.data)
	#plan._draw_WFC()

func _on_iterate_pressed():
	pass
	#if not plan.WFC: return
	#plan.WFC.solve(true)
	#plan._draw_WFC()

func _on_collapse_pressed():
	pass
	#if not plan.WFC: return
	#plan.WFC.solve(false)
	#plan._draw_WFC()
