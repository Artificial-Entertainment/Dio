extends RichTextLabel

@export_file("*.res") var _examplePath: String
var _currentNode: String = "node1" # all dialogues start from node1
var _dialogue: Dictionary = {}

func _ready() -> void:
	# grab _dialogue
	var graphState: GraphState = ResourceLoader.load(_examplePath)
	_dialogue = graphState.get_dialogue()
	meta_clicked.connect(on_meta_clicked)
	show_dialogue(_currentNode)
	return

func show_dialogue(nodeId: String) -> void:
	set_text("")
	var node: Dictionary = _dialogue[nodeId]
	append_text("[b]%s[/b]\n" % node["name"])
	append_text("%s\n\n" % node["text"])
	show_options(node["choices"], node["connections"])
	return

func show_options(choices: PackedStringArray, connections: Array) -> void:
	if connections.size():
		for i in range(choices.size()):
			append_text("%d. [url=%s]%s[/url]\n" % [i + 1, connections[i], choices[i]])
	else:
		append_text("1. [url=end]Exit[/url]\n")
	return

func on_meta_clicked(meta: String) -> void:
	if meta == "continue":
		_currentNode = _dialogue[_currentNode]["connections"][0]
	elif meta == "end":
		get_tree().quit()
	else:
		_currentNode = meta
	show_dialogue(_currentNode)
	return
