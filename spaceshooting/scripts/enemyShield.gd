extends Area2D

var parent = true

func _ready() -> void:
	if parent:
		return
	$shield.visible = true
	
func set_parent(value: bool) -> void:
	parent = value

func die():
	self.queue_free()
	self.get_parent().set_shielded(false)
