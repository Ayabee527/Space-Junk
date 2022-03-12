extends CanvasLayer


func _ready() -> void:
	pass

func pause():
	$MarginContainer.visible = true
	$MarginContainer.mouse_filter = Control.MOUSE_FILTER_STOP

func unpause():
	$MarginContainer.visible = false
	$MarginContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_ResumeButt_pressed() -> void:
	get_parent().unpause()


func _on_MenuButt_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
