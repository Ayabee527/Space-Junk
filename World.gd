extends Node2D

var score = 0
var paused = false

func _ready() -> void:
	randomize()
	$NormalLayer/EnemySpawner.player = $NormalLayer/Player
	unpause()


func _on_ScoreTimer_timeout() -> void:
	if !$NormalLayer/Player.dead and !paused:
		score += 1
		$HUDLayer/HUD.update_score(score)
		$NormalLayer/EnemySpawner.score = score


func pause():
	paused = true
	$PauseMenu.pause()
	$NormalLayer/EnemySpawner.paused = true
	$NormalLayer/Player.paused = true
	for i in get_children():
		if i.has_method("norm_ai") or i.has_method("junk_ai"):
			i.paused = true

func unpause():
	paused = false
	$PauseMenu.unpause()
	$NormalLayer/EnemySpawner.paused = false
	$NormalLayer/Player.paused = false
	for i in get_children():
		if i.has_method("norm_ai") or i.has_method("junk_ai"):
			i.paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pause()
