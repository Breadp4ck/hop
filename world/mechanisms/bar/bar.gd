class_name Bar
extends Mechanism

func use() -> void:
	animator.play("Open")

# Animator
func end() -> void:
	body_collision.disabled = true
