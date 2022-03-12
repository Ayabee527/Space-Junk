extends Area2D

enum BulletType {
	NORMAL
	HOMING
}

export (BulletType) var type = BulletType.NORMAL
export (int) var speed = 200

var paused = false

func _ready() -> void:
	pass


func norm_ai(delta):
	position += transform.x * speed * delta


func _physics_process(delta: float) -> void:
	if !paused:
		match type:
			BulletType.NORMAL:
				norm_ai(delta)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	body.hurt()
	queue_free()
