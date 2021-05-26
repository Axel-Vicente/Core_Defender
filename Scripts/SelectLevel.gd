extends Node2D
onready var sleep_on = preload("res://Assets/ButtonsLayout/SleepDownRed.png")
onready var sleep_off = preload("res://Assets/ButtonsLayout/SleepIdle.png")

func _on_PowerButton_pressed():
	get_tree().quit()

func _on_SleepButton_pressed():
	if get_tree().paused == true:
		$SleepButton.texture_normal = sleep_off
		get_tree().paused = false
	else:
		$SleepButton.texture_normal = sleep_on
		get_tree().paused = not get_tree().paused

func _on_Level1_pressed():
	get_tree().change_scene("res://Scenes/CoreDefender.tscn")
