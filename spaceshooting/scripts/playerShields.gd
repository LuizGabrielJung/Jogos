extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if self.name == "invincible":
		return
	if "enemyBullet" in area.get_groups():
		area.die()
		self.queue_free()
	if "enemy" in area.get_groups():
		self.queue_free()
