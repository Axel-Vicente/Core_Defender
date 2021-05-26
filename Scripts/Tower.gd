extends Node2D

var enemy_array = []

signal shoot_projectile

var tilemap
var cell_size
var current_tile

func _ready():
	tilemap = get_parent().get_parent().get_node("TileMap")
	cell_size = tilemap.cell_size

func _on_Aggro_area_entered(area):
	if "virus_enemy" in area.name:
		enemy_array.append(area)
		yield(get_tree().create_timer(1), "timeout")
		$pew_sound.play()

func _on_Aggro_area_exited(area):
	if "virus_enemy" in area.name and enemy_array.size() > 0:
		enemy_array.erase(area)

func _on_Shoot_Timer_timeout():
	if enemy_array.size() > 0:
		var projectile_origin_pos = position + Vector2(32, 32) # Middle of the tower
		emit_signal("shoot_projectile", projectile_origin_pos, enemy_array[0].position)
