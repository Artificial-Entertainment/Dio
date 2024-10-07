@tool
extends EditorPlugin

var _packedScene: PackedScene = preload("res://addons/dialogue/graph/graph.tscn")
var _pluginControl: Control = null

func _enter_tree() -> void:
	_pluginControl = _packedScene.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_pluginControl)
	_pluginControl.hide()
	return

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	_pluginControl.set_visible(visible)
	return

func _get_plugin_name() -> String:
	return "Dialogue"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Window", "EditorIcons")
