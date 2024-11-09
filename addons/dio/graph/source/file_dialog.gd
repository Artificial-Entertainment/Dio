@tool
extends FileDialog

@export var _graph: GraphEdit
const DEFAULT_SAVE_LOC: String = "res://dio_graph.res"
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
		process_save_file(path)
	elif file_mode == FILE_MODE_OPEN_FILE:
		process_open_file(path)
	return

func process_autosave() -> void:
	if _openFilePath.is_empty():
		process_save_file(DEFAULT_SAVE_LOC)
	else:
		process_save_file(_openFilePath)
	return

func process_save_file(path: String) -> void:
	var graphState: GraphState = GraphState.new()
	graphState.collect_graph_state(_graph)
	var err: Error = ResourceSaver.save(graphState, path)
	if err != OK:
		push_error("Error saving file: " + error_string(err))
	_openFilePath = path
	return

func process_open_file(path: String) -> void:
	var resource: Resource = ResourceLoader.load(path)
	if resource == null:
		push_error("Failed to load resource from file: " + path)
		return
	if !(resource is GraphState):
		push_error("Loaded resource is not a GraphState: " + path)
		return
	_openFilePath = path
	resource.apply_graph_state(_graph)
	return
