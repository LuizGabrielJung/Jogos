extends Area2D

var canShoot = true
var shoots = true
var fireRate = 0.5
var bulletSpeed = 200
var speed = 60
var health = 1
var damage = 1
var alive = true
var movement = []
var nextIndex = 0
var shielded = false
var parent = true

func _ready() -> void:
	if $weapon:
		$weapon.connect("animation_finished", weapon_animation)
	
func _process(delta: float) -> void:
	if !alive or parent:
		return
	if shoots:
		shoot()
	if movement != []:
		var target = movement[nextIndex]
		if typeof(target) == 4:
			if target == "end":
				movement = []
				die()
				return
		var localSpeed = speed
		if target.size() == 2:
			localSpeed = target[1]
		target = target[0]
		
		if typeof(localSpeed) == 4:
			if localSpeed == "instant":
				self.position = target
				set_nextIndex(nextIndex + 1)
				return
		var direction = (target - self.position).normalized()
		var distance = self.position.distance_to(target)
		self.position += direction * localSpeed * delta
		if distance < localSpeed * 5 / 100:
			self.position = target
			set_nextIndex(nextIndex + 1)
	
func shoot():
	if canShoot and $weapon:
		set_canShoot(false)
		get_tree().create_timer(fireRate).timeout.connect(func(): set_canShoot(true))
		
		#$weapon.speed_scale = 1 / fireRate
		$weapon.play('shooting')
		
		var new_bullet = $bullet.duplicate()
		new_bullet.set_speed(bulletSpeed)
		new_bullet.set_damage(damage)
		new_bullet.position = $ship.global_position
		new_bullet.rotation = PI
		new_bullet.monitorable = true
		new_bullet.parent = false
		get_tree().get_root().add_child(new_bullet)

func weapon_animation() -> void:
	if $weapon.animation_finished:
		$weapon.play('default')
	
func set_fireRate(value: float) -> void:
	fireRate = value
	
func set_bulletSpeed(value: float) -> void:
	bulletSpeed = value
	
func set_speed(value: float) -> void:
	speed = value
	
func set_parent(value: bool) -> void:
	parent = value
	
func set_canShoot(value: bool) -> void:
	canShoot = value
	
func set_shoots(value: bool) -> void:
	shoots = value
	
func set_health(value: float) -> void:
	health = value
	
func set_damage(value: float) -> void:
	damage = value
	
func set_alive(value: bool) -> void:
	alive = value
	
func set_shield(value: bool = true) -> void:
	if $shield:
		if value == true:
			set_shielded(true)
			var newShield = $shield.duplicate()
			newShield.set_parent(false)
			newShield.monitorable = true
			add_child(newShield)
		if value == false:
			set_shielded(false)
			for child in get_children():
				if "enemyShield" in child.get_groups():
					if child.parent:
						continue
					child.queue_free()

func set_shielded(value: bool) -> void:
	shielded = value
	
func set_movement(value: Array) -> void:
	movement = value
	
func set_nextIndex(value: int) -> void:
	nextIndex = value
	if nextIndex > movement.size() - 1:
		nextIndex = 0
	if nextIndex < 0:
		nextIndex = 0
	
func takeDamage(value: float) -> void:
	if !alive:
		return
	if shielded:
		return
	health -= value
	if health <= 0:
		die()

func die() -> void:
	set_alive(false)
	for child in get_children():
		if child.name == "ship" or "enemyBullet" in child.get_groups():
			continue
		child.visible = false
	$ship.play("explosion")
	$ship.connect("animation_finished", queue_free)
