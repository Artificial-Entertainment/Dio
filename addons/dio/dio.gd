@tool
extends EditorPlugin

var _graph: GraphEdit = null

func _enter_tree() -> void:
	_graph = preload("res://addons/dio/graph/graph.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(_graph)
	_graph.hide()
	return

func _save_external_data() -> void:
	_graph.autosave()
	return

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	_graph.set_visible(visible)
	return

func _get_plugin_name() -> String:
	return "Dio"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Window", "EditorIcons")
