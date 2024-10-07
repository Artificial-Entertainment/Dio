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
	file_selected.connect(process_file)
	return

func preset(type: String) -> void:
	set_ok_button_text(FILE_PRESETS[type].ok_text)
	set_file_mode(FILE_PRESETS[type].file_mode)
	set_title(FILE_PRESETS[type].title)
	popup_centered_ratio()
	return

func process_file(path: String) -> void:
	var fileMode: int = get_file_mode()
	if fileMode == FILE_MODE_SAVE_FILE:
		var graph_state: GraphState = GraphState.new()
		graph_state.collect_graph_state(_graph)
		var err: Error = ResourceSaver.save(graph_state, path)
		if err:
			push_error(error_string(err))
	elif fileMode == FILE_MODE_OPEN_FILE:
		var graph_state: GraphState = ResourceLoader.load(path)
		if graph_state == null:
			push_error("Failed to load the graph state.")
			return
		graph_state.apply_graph_state(_graph)
	return
