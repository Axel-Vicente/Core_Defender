extends Node2D

onready var mob = preload("res://Scenes/Virus.tscn")
onready var tower = preload("res://Scenes/Tower.tscn")
onready var projectile = preload("res://Scenes/Shoot.tscn")

onready var sleep_on = preload("res://Assets/ButtonsLayout/SleepDownRed.png")
onready var sleep_off = preload("res://Assets/ButtonsLayout/SleepIdle.png")

onready var soundtrack = [preload("res://SoundEffects/track_1.ogg"), preload("res://SoundEffects/track_3.ogg"), preload("res://SoundEffects/track_2.ogg")]
onready var current_soundtrack = 0

var mobs_reamaining = 0
var can_place_tower = false
var building = false
var cash = 50
var invalid_tiles
var valid_tiles

var frameIni = 15
var proccesor_life = 16

var instance

func _ready():
	$life_bar.set_frame(int(frameIni))
	# start the timer
	$WaveTimer.start(5)
	$Cash.text = "cash:  " + str(cash)
	mobs_reamaining = 30
	
	# Get the position to the valid tiles "the base of tower"
	valid_tiles = get_valid_tiles()

	# Towers cannot be placed on these tiles
	invalid_tiles = $nav/TileMap_road.get_used_cells()

func _unhandled_input(event):
	if event is InputEventMouseMotion and can_place_tower:
		$Tower_placement.clear()
		
		# Get the tile location of the mouse cursor
		var tile = $Tower_placement.world_to_map(event.position)
		
		for i in valid_tiles:
			if tile in valid_tiles and not tile in invalid_tiles:
				# Color green / valid tile
				$Tower_placement.set_cell(tile.x, tile.y, 1)
			else:
				# Color red / invalid tile
				$Tower_placement.set_cell(tile.x, tile.y, 0)
	
	elif event is InputEventMouseButton and can_place_tower and event.pressed:
		# Get the tile location of the mouse cursor
		var tile = $Tower_placement.world_to_map(event.position)
		for i in valid_tiles:
			if tile in valid_tiles and not tile in invalid_tiles:
				can_place_tower = false
				$Tower_placement.clear()
				
				# The tile is now invalid for other towers
				invalid_tiles.append(tile)
				
				# Place the tower
				var tower_instance = tower.instance()
				tower_instance.connect("shoot_projectile", self, "shoot_projectile")
				tower_instance.position = Vector2((tile.x+0.5)*64,(tile.y+0.5)*64)
				$Entities.add_child(tower_instance)
				cash -= 25
				$Cash.text = "cash:  " + str(cash)

func _on_PowerButton_pressed():
	get_tree().quit()

func get_valid_tiles():
	# Loop that runs through the two-dimensional array of tiles
	var valid_tiles = []
	for i in range(0,18):
		for j in range(0,14):
			var cell = $TileMap.get_cellv(Vector2(i,j))
			if cell == 6:
				valid_tiles.append(Vector2(i,j))
	return valid_tiles

func _on_SleepButton_pressed():
	if get_tree().paused == true:
		$SleepButton.texture_normal = sleep_off
		get_tree().paused = false
	else:
		$SleepButton.texture_normal = sleep_on
		get_tree().paused = not get_tree().paused

func shoot_projectile(origin, target):
	var projectile_instance = projectile.instance()
	projectile_instance.origin_pos = origin
	projectile_instance.target_pos = target
	$Entities.add_child(projectile_instance)

func _on_WaveTimer_timeout():
	
	# Make an instance of the mob
	var mob_instance = null
	mob_instance = mob.instance()
	mob_instance.connect("Virus_defeated", self, "Virus_defeated")
	mob_instance.connect("processorDamage", self, "processorDamage")
	
	# Add new child to path2d
	$Path_enemy.add_child(mob_instance)
	
	# Add the mob to the entities container
	$Entities.add_child(mob_instance)
	
	mobs_reamaining -= 1
	if mobs_reamaining > 0:
		# Seconds it takes to take out another enemy
		$WaveTimer.start(1.5)

func _on_Build_tower_pressed():
	if  cash >= 25:
		$Build_Sound.play()
		$Tower_placement.clear()
		can_place_tower = !can_place_tower
	else: 
		pass
		
func Virus_defeated():
	pass

func _on_CashTimer_timeout():
	cash += 1
	$Cash.text = "cash:  " + str(cash)

func _on_Area2D_area_entered(area):
	if "virus_enemy" in area.name:
			for i in range(4):
				yield(get_tree().create_timer(0.3), "timeout")
				frameIni -= 1
				$life_bar.set_frame(int(frameIni))
				if frameIni <= 0:
					get_tree().change_scene("res://Scenes/GameOver.tscn")
	
func _change_music():
	print("hola")
	current_soundtrack += 1
	print($Background_Music.stream)
	if current_soundtrack == 3:
		current_soundtrack = 0
	$Background_Music.stream = soundtrack[current_soundtrack]
	$Background_Music.play()


func _on_Background_Music_finished():
	print("hola")
	_change_music()
