extends RichTextLabel

var dialogue: Dictionary

func _ready() -> void:
	var graphState: GraphState = ResourceLoader.load("res://addons/dio/example/resource/example.res")
	dialogue = graphState.get_dialogue()
	print(dialogue)
	return
