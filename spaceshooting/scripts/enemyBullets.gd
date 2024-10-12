extends Area2D

var speed = 100
var parent = true
var damage = 1

func _ready() -> void:
	if parent:
		return
	self.visible = true
	
func _process(delta: float) -> void:
	if parent:
		return
	self.position.y += speed * delta
	if self.global_position.y >= 640:
		self.queue_free()
	
func set_speed(value: float) -> void:
	speed = value
	
func set_damage(value: float) -> void:
	damage = value
	
func set_parent(value: bool) -> void:
	parent = value
	
func die():
	if parent:
		return
	self.parent = true
	#$bullet.play("explosion")
	#$bullet.connect("animation_finished", queue_free)
	queue_free()
