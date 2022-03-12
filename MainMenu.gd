extends Control


func _ready() -> void:
	$MenuLayer/PanelContainer/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Highscore.text = "Highscore: " + str(Global.highscore)


func _on_PlayButt_pressed() -> void:
	get_tree().change_scene("res://World.tscn")


func _on_QuitButt_pressed() -> void:
	get_tree().quit()
