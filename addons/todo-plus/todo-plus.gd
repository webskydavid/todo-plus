@tool
extends EditorPlugin

var window: Control

func _enter_tree() -> void:
	window = preload('todo_plus_window.tscn').instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, window)
	prints('jfweojfweo')


func _exit_tree() -> void:
	remove_control_from_docks(window)
	window.free()
