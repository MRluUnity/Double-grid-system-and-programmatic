extends CharacterBody2D

@export var spped : float = 2500.

var dir : Vector2

func _process(delta: float) -> void:
	dir = get_dir()
	
func _physics_process(delta: float) -> void:
	velocity = dir * spped
	move_and_slide()

func get_dir() -> Vector2:
	return Input.get_vector("action_left", "action_right", "action_up", "action_down")
