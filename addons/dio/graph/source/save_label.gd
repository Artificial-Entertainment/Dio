@tool
extends Label

func write_text(t: String) -> void:
	show()
	set_text(t)
	var tween: Tween = create_tween()
	tween.tween_method(set_modulate, Color.WHITE, Color.TRANSPARENT, 2.5)
	tween.finished.connect(hide)
	return
