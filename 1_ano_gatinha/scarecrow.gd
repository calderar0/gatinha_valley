extends Machine

signal shoot_projectile(start_pos: Vector2, dir: Vector2)

func _on_timer_timeout() -> void:
	var blobs = get_tree().get_nodes_in_group("Blobs")
	if blobs:
		shoot_projectile.emit(position, (get_nearest_blob(blobs).position - position).normalized())

func get_nearest_blob(blobs: Array) -> CharacterBody2D:
	var nearest = blobs[0]
	for blob in blobs:
		if blob.position.distance_to(position) <= nearest.position.distance_to(position):
			nearest = blob
	return nearest
