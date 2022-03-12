extends StateMachine


func _ready() -> void:
	add_state("normal")
	add_state("hurt")
	add_state("dash")
	call_deferred("set_state", states.normal)


func _state_logic(delta):
	pass


func _get_transition(delta):
	return null


func _enter_state(new_state, old_state):
	pass


func _exit_state(old_state, new_state):
	pass
