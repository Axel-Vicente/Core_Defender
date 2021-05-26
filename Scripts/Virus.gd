extends PathFollow2D

var destination = Vector2()
var speed = 100
var hp = 10
var frameIni = 15

func _physics_process(delta):
	set_offset(get_offset() + speed * delta)
	if loop == false and get_unit_offset() == 1:
		queue_free()
		
