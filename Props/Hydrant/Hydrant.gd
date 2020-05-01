extends Node

var has_finished_spawning: bool = false

func _on_Timer_timeout() -> void:
	queue_free()

func _on_FlipArea_body_entered(body: Node) -> void:
	$Flipper/AnimationPlayer.play('CarPush')

func _on_FireHydrant__sleeping_state_changed() -> void:
	if not $FireHydrant.sleeping and has_finished_spawning:
		$Particles.emitting = true
		$Timer.start()
	else:
		has_finished_spawning = true
