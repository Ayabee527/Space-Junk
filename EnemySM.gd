extends StateMachine


func _ready() -> void:
	add_state("normal")
	add_state("angry")
	call_deferred("set_state", states.normal)


func _state_logic(delta):
	if !parent.paused:
		match state:
			states.normal:
				if parent.type == parent.EnemyTypes.JUNK:
					parent.junk_ai(delta)
				if parent.type == parent.EnemyTypes.LAUNCHER:
					parent.launcher_ai(delta)
				if parent.type == parent.EnemyTypes.BOUNCER:
					parent.bouncer_bounce(delta)
			states.angry:
				parent.bouncer_burst(delta)
	else:
		parent.dumb(delta)


func _get_transition(delta):
	if parent.type == parent.EnemyTypes.BOUNCER:
		if parent.can_angry():
			return states.angry


func _enter_state(new_state, old_state):
	pass


func _exit_state(old_state, new_state):
	pass
