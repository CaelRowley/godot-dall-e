@tool
extends EditorPlugin

var dock := preload("res://addons/texture_generator_plugin/texture_generator_dock.tscn").instantiate() as Control


func _enter_tree():
	add_control_to_dock(DOCK_SLOT_LEFT_BL, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
