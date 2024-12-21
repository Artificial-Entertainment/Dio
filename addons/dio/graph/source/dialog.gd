@tool
extends FileDialog

@export var _graph: GraphEdit
@export var _saveLabel: Label
const SAVE_DIR: String = "res://addons/dio/saves/"
const ROOT_DIR: String = "res://"
var _openFilePath: String = ""

func _ready() -> void:
	file_selected.connect(on_file_selected)
	return

func save_preset() -> void:
	set_ok_button_text("Open")
	set_file_mode(FILE_MODE_SAVE_FILE)
	set_title("Open a File")
	return

func load_preset() -> void:
	set_ok_button_text("OK")
	set_file_mode(FILE_MODE_OPEN_FILE)
	set_title("Save a File")
	return

func on_file_selected(path: String) -> void:
	if file_mode == FILE_MODE_SAVE_FILE:
		save_file(path)
	elif file_mode == FILE_MODE_OPEN_FILE:
		load_file(path)
	return

func autosave() -> void:
	if _openFilePath.is_empty():
		var dir: DirAccess = DirAccess.open(SAVE_DIR)
		if dir == null:
			dir = DirAccess.open(ROOT_DIR)
		var count: int = dir.get_files().size() + 1
		var saveName: String = "dio%s.res" % count
		save_file(SAVE_DIR + saveName)
	else:
		save_file(_openFilePath)
	return

func save_file(path: String) -> void:
	var graphState: GraphState = GraphState.new()
	var graphErr: Error = graphState.collect_graph_state(_graph)
	if graphErr != OK:
		return # dialogue state empty | do not save

	var resErr: Error = ResourceSaver.save(graphState, path)
	_saveLabel.write_text("Saved at %s" % path)
	if resErr != OK:
		push_error("Error saving file: " + error_string(resErr))

	_openFilePath = path
	return

func load_file(path: String) -> void:
	var resource: Resource = ResourceLoader.load(path)
	if resource == null:
		push_error("Failed to load resource from file: " + path)

	if !(resource is GraphState):
		push_error("Loaded resource is not a GraphState: " + path)

	_openFilePath = path
	resource.apply_graph_state(_graph)
	return

