@tool
extends FileDialog

@export var _graph: GraphEdit
const FILE_PRESETS: Dictionary = {
	"save": {
		"ok_text": "OK",
		"file_mode": FILE_MODE_SAVE_FILE,
		"title": "Save a File"
	},
	"load": {
		"ok_text": "Open",
		"file_mode": FILE_MODE_OPEN_FILE,
		"title": "Open a File"
	}
}

func _ready() -> void:
	file_selected.connect(on_file_selected)
	return

func preset(type: String) -> void:
	set_ok_button_text(FILE_PRESETS[type].ok_text)
	set_file_mode(FILE_PRESETS[type].file_mode)
	set_title(FILE_PRESETS[type].title)
	popup_centered_ratio()
	return

func on_file_selected(path: String) -> void:
	if file_mode == FILE_MODE_SAVE_FILE:
		process_save_file(path)
	elif file_mode == FILE_MODE_OPEN_FILE:
		process_open_file(path)
	return

func process_save_file(path: String) -> void:
	var graphState: GraphState = GraphState.new()
	graphState.collect_graph_state(_graph)
	var err: Error = ResourceSaver.save(graphState, path)
	if err != OK:
		push_error("Error saving file: " + error_string(err))
	return

func process_open_file(path: String) -> void:
	var graphState: GraphState = ResourceLoader.load(path)
	if graphState == null:
		push_error("Failed to load graph state from file: " + path)
		return
	elif graphState is not GraphState:
		push_error("Loaded resource is not a GraphState: " + path)
		return
	graphState.apply_graph_state(_graph)
	return
