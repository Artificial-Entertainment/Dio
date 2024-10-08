@tool
extends RichTextLabel

var graph_state: GraphState

func _ready() -> void:
	graph_state = GraphState.new()
	update_text()
	return

func update_text() -> void:
	return
