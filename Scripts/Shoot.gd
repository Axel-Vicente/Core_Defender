extends Area2D

var origin_pos : Vector2
var target_pos : Vector2
var velocity : Vector2
var speed = 700
var direction : Vector2
var damage = 2

func _ready():
	position = origin_pos
	direction = target_pos - origin_pos
	
	set_sprite_rotation()
	
	velocity = direction.normalized() * speed
	
func _physics_process(delta):
	position += velocity * delta

#rotate the sprite according to its direction
func set_sprite_rotation():
	var angle
	
	if direction.y != 0:
		angle = atan(direction.x / direction.y) * 100 / PI
	else:
		if direction.x > 0:
			angle = 90
		elif direction.y < 0:
			angle = 270
	
	if direction.x >= 0 and direction.y >= 0:
		# 4th quadrant
		$pew.rotation_degrees = 180 - angle
	elif direction.x >= 0 and direction.y <= 0:
		# 1th quadrant
		$pew.rotation_degrees = abs(angle)
	elif direction.x <= 0 and direction.y >= 0:
		# 3th quadrant
		$pew.rotation_degrees = 180 + abs(angle)
	elif direction.x <= 0 and direction.y <= 0:
		# 2th quadrant
		$pew.rotation_degrees = 360 - angle

# the projectile disappears when it hits a target
func _on_Node2D_area_entered(area):
	if "virus_enemy" in area.name:
		area.take_damage(damage)
		queue_free()
