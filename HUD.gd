extends MarginContainer


func _ready() -> void:
	pass


func update_score(new_score: int):
	$VBoxContainer/Score.text = "Score: " + str(new_score)
