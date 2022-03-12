extends KinematicBody2D


export (int) var max_speed = 200
export (int) var max_rotate_speed = 45
export (int) var acceleration = 20
export (int) var friction = 10
export (int) var rotate_lerp = 5

var velocity = Vector2()
var cur_rotate_speed = 0
var shield_num = 8
var shield_spin_dir = 1
var dashing = false
var dead = false

var paused = false

var Shield = preload("res://Shield.tscn")

signal died

func _ready() -> void:
	gen_shields()


func gen_shields():
	var ang = 360 / shield_num
	for i in range(shield_num):
		var shield = Shield.instance()
		shield.global_position = Vector2($Shields.position.x + 16, 0).rotated(deg2rad(ang * i))
		shield.global_rotation_degrees = ang * i
		$Shields.add_child(shield)


func invinclible(duration: float):
	$CollisionPolygon2D.disabled = true
	$InvincibiltyTimer.start(duration)

func dash():
	if !dashing:
		if Input.is_action_pressed("ui_accept"):
			$DashSound.play()
			dashing = true
			$DashTimer.start(0.25)
			invinclible(0.5)
	if dashing:
		velocity = Vector2(max_speed * 2, 0).rotated(rotation)
		velocity = move_and_slide(velocity)


func get_input(delta):
	var max_vel = Vector2(max_speed, 0).rotated(rotation)
	if Input.is_action_pressed("ui_up"):
		velocity = lerp(velocity, max_vel, acceleration * delta)
		$Emissions.emitting = true
	elif Input.is_action_pressed("ui_down"):
		velocity = lerp(velocity, -max_vel/2, acceleration * delta)
		$Emissions.emitting = false
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
		$Emissions.emitting = false
	
	if Input.is_action_pressed("ui_left"):
		cur_rotate_speed = -max_rotate_speed
		shield_spin_dir = -1
	elif Input.is_action_pressed("ui_right"):
		cur_rotate_speed = max_rotate_speed
		shield_spin_dir = 1
	else:
		cur_rotate_speed = lerp(cur_rotate_speed, 0, rotate_lerp * delta)
	
	rotation_degrees += cur_rotate_speed * delta
	
	velocity = move_and_slide(velocity)


func shield_rotate(delta):
	if abs(cur_rotate_speed) < max_rotate_speed/5:
		$Shields.rotation_degrees += 90 * delta * shield_spin_dir
	else:
		$Shields.rotation_degrees += (cur_rotate_speed/2) * delta
	for s in $Shields.get_children():
		if abs(cur_rotate_speed) < max_rotate_speed/5:
			s.rotation_degrees += 135 * delta
		else:
			s.rotation_degrees += (cur_rotate_speed/2) * delta * shield_spin_dir


func _physics_process(delta: float) -> void:
	if !paused:
		if !dashing:
			get_input(delta)
		dash()
		
		shield_rotate(delta)
	
	if position.x <= 0:
		position.x = 0
	if position.x >= 360:
		position.x = 360
	if position.y <= 0:
		position.y = 0
	if position.y >= 180:
		position.y = 180


func hurt():
	$HitSound.play()
	if !paused:
		if $Shields.get_child_count() > 0:
			$Shields.get_child(0).queue_free()
			$Shields.remove_child($Shields.get_child(0))
			invinclible(0.75)
			if $Shields.get_child_count() >= 1:
				var ang = 360 / $Shields.get_child_count()
				for s in $Shields.get_child_count():
					var shield = $Shields.get_child(s)
					var pos = Vector2($Shields.position.x + 16, 0).rotated(deg2rad(ang * s))
					$Tween.interpolate_property(shield, "position", shield.position, pos, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
					$Tween.start()
		else:
			dead = true
			modulate.a = 0
			if get_parent().get_parent().score > Global.highscore:
				Global.highscore = get_parent().get_parent().score
			get_tree().change_scene("res://MainMenu.tscn")


func _on_DashTimer_timeout() -> void:
	dashing = false


func _on_InvincibiltyTimer_timeout() -> void:
	$CollisionPolygon2D.disabled = false
