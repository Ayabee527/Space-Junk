extends Area2D


enum EnemyTypes {
	JUNK
	LAUNCHER
	BOUNCER
}

var Bullet = preload("res://Bullet.tscn")

export (EnemyTypes) var type = EnemyTypes.JUNK

var can_shoot = true
var shoot_cooldown = 0.5
var player = null
var phase = 0

var paused = false

func _ready() -> void:
	init()


func gen_shoots(shoots: int, ang_offset: int = 0):
	var ang = (360 / shoots)
	for i in range(shoots):
		var pos = Position2D.new()
		pos.global_position = Vector2($ShotRotator.position.x + 4, 0).rotated(deg2rad(ang * i) + ang_offset)
		pos.global_rotation_degrees = ang * i
		$ShotRotator.add_child(pos)


func init():
	match type:
		EnemyTypes.JUNK:
			modulate.r = 0.5
		EnemyTypes.LAUNCHER:
			modulate.b = 0.5
			shoot_cooldown = 0.5
			gen_shoots(1)
		EnemyTypes.BOUNCER:
			modulate.g = 0.5
			shoot_cooldown = 0.3
			gen_shoots(2)


func mine_shoot():
	if can_shoot:
		can_shoot = false
		$ShootTimer.start(shoot_cooldown)
		for p in $ShotRotator.get_child_count():
			var bullet = Bullet.instance()
			var pos: Position2D = $ShotRotator.get_child(p)
			bullet.global_position = pos.global_position
			bullet.global_rotation = pos.global_rotation
			get_parent().add_child(bullet)


func dumb(delta):
	position += Vector2.ZERO


func junk_ai(delta):
	position.x -= 150 * delta
	rotation_degrees += 60 * delta


func launcher_ai(delta):
	position.x -= 200 * delta
	mine_shoot()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	match type:
		EnemyTypes.JUNK, EnemyTypes.LAUNCHER:
			if position.x < 50:
				queue_free()


func _on_ShootTimer_timeout() -> void:
	can_shoot = true
	$ShootTimer.start(shoot_cooldown)


func _on_Enemy_body_entered(body: Node) -> void:
	body.hurt()


func bouncer_bounce(delta):
	look_at(player.position)
	position += position.direction_to(player.position) * 150 * delta


func bouncer_shoot():
	if can_shoot:
		can_shoot = false
		if $ExplodeTimer.time_left <= 0:
			$ExplodeTimer.start(1)
		$ShootTimer.start(shoot_cooldown)
		for p in $ShotRotator.get_child_count():
			var bullet = Bullet.instance()
			var pos: Position2D = $ShotRotator.get_child(p)
			bullet.global_position = pos.global_position
			bullet.global_rotation = pos.global_rotation
			get_parent().add_child(bullet)


func bouncer_burst(delta):
	look_at(player.position)
	$ShotRotator.look_at(player.position)
	bouncer_shoot()


func can_angry():
	if position.distance_to(player.position) <= 128:
		return true


func _on_ExplodeTimer_timeout() -> void:
	queue_free()
