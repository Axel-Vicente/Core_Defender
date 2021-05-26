extends Area2D

var hp = 10

func _on_Area2D_area_entered(area):
	if area.is_in_group("shot"):
		area.queue_free()
		hp -= 1
		if hp <= 0:
			get_parent().get_parent().add_cash(5)
			queue_free()

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("Virus_defeated")
		queue_free()
