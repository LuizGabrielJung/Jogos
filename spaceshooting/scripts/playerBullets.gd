extends Node2D

var speed = 100
var damage = 1
var parent = true

func _ready() -> void:
	if parent:
		return
	self.visible = true

func _process(delta: float) -> void:
	if parent:
		return
	self.position.y -= speed * delta
	if self.global_position.y <= 0:
		self.queue_free()
	
func set_speed(value: float) -> void:
	speed = value
	
func set_damage(value: float) -> void:
	damage = value
	
func set_parent(value: bool) -> void:
	parent = value

func _on_area_entered(area: Area2D) -> void:
	if parent:
		return
	if "enemyShield" in area.get_groups():
		set_parent(true)
		area.die()
		$bullet.play("explosion")
		$bullet.connect("animation_finished", queue_free)
	if "enemy" in area.get_groups():
		if !area.alive:
			return
		if area.shielded:
			return
		set_parent(true)
		if "biggun" in self.get_groups():
			$bullet.scale = Vector2(0.7, 0.7)
		if "cannon" in self.get_groups():
			$bullet.scale = Vector2(0.5, 0.5)
		$bullet.play("explosion")
		$bullet.connect("animation_finished", queue_free)
		area.takeDamage(damage)
		
