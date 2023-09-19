@tool
extends EditorPlugin

var dock


func _enter_tree():
	dock = preload("res://addons/texturegeneratorplugin/texture_generator_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BL, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
