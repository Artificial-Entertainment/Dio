extends RichTextLabel

var _currentNode: String = "node1" # all dialogues start from node1
var _dialogue: Dictionary = {}

func _ready() -> void:
	# grab dialogue
	var graphState: GraphState = ResourceLoader.load("res://addons/dio/example/resource/example.res")
	_dialogue = graphState.get_dialogue()
	# signals
	meta_clicked.connect(on_meta_clicked)
	show_dialogue(_currentNode)
	return

func show_dialogue(nodeId: String) -> void:
	set_text("")
	var node: Dictionary = _dialogue[nodeId]
	append_text("[b]%s[/b]\n" % node["name"])
	append_text("%s\n\n" % node["text"])
	var numChoices: int = node["choices"].size()
	var choices: PackedStringArray = node["choices"]
	var cons: Array = node["connections"]
	if numChoices == 0:
		if cons.size() > 0:
			append_text("1. [url=continue]Continue[/url]\n")
		else:
			append_text("1. [url=end]Leave[/url]\n")
	else:
		for i in range(numChoices):
			append_text("%d. [url=%s]%s[/url]\n" % [i + 1, cons[i], choices[i]])
	return

func on_meta_clicked(meta: String) -> void:
	if meta == "continue":
		_currentNode = _dialogue[_currentNode]["connections"][0]
		show_dialogue(_currentNode)
	elif meta == "end":
		queue_free()
	else:
		_currentNode = meta
		show_dialogue(_currentNode)
	return
