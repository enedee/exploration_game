extends Area3D

var active = false

func _process(delta: float) -> void:
	if active and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://levels/rooftop.tscn")

func _on_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		print(active)
		active = true

func _on_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		print(active)
		active = false
