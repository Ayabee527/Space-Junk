extends Node2D


onready var right_spawn = $RightSpawnPath/PathFollow2D/RightSpawn
var Enemy = preload("res://Enemy.tscn")

var can_spawn = true
var player = null
var score = 0
var max_wait = 1.0

var paused = false

func _ready() -> void:
	pass


func spawn():
	if can_spawn:
		can_spawn = false
		$RightSpawnPath/PathFollow2D.offset += rand_range(-100, 100)
		$SpawnTimer.start(rand_range(0.15, max_wait))
		var enemy = Enemy.instance()
		enemy.player = player
		if score < 20:
			enemy.type = randi() % 1
			max_wait = 1.0
		elif score >= 20 and score < 60:
			enemy.type = randi() % 2
			max_wait = 0.75
		elif score >= 60:
			enemy.type = randi() % 3
			max_wait = 0.5
		enemy.global_position = right_spawn.global_position
		get_parent().add_child(enemy)


func _process(delta: float) -> void:
	if !paused:
		spawn()
		$RightSpawnPath/PathFollow2D.offset += 50 * delta


func _on_SpawnTimer_timeout() -> void:
	can_spawn = true
