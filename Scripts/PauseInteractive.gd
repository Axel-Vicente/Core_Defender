extends Control

var icon_languages = load("res://Images/Languages.png")
var icon_spain = load("res://Images/Language_Spain.png")
var icon_english = load("res://Images/Language_English.png")
var icon_french = load("res://Images/Language_French.png")
var icon_italian = load("res://Images/Language_Italian.png")

var music_on = true
onready var speaker_on = preload("res://Images/Speaker.png")
onready var speaker_off = preload("res://Images/SpeakerMuted.png")


func _ready():
	#Add Items to the language button
	add_items()
	
#Function to adding items
func add_items():
	$LanguageButton.add_separator()
	$LanguageButton.add_icon_item(icon_spain, "es", 1)
	$LanguageButton.add_icon_item(icon_english, "en", 2)
	$LanguageButton.add_icon_item(icon_french, "fr", 3)
	$LanguageButton.add_icon_item(icon_italian, "it", 4)

func _on_LanguageButton_item_selected(id):
	if id == 2: TranslationServer.set_locale("es")
	elif id == 3: TranslationServer.set_locale("en")
	elif id == 4: TranslationServer.set_locale("fr")
	elif id == 5: TranslationServer.set_locale("it")


func _on_Resume_button_down():
	$Resume/ResumeText.add_color_override("font_color", Color(1,1,1,1))


func _on_Resume_button_up():
	$Resume/ResumeText.add_color_override("font_color", Color(0,0,0,1))
	
func _on_Resume_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_Exit_button_down():
	$Exit/ExitText.add_color_override("font_color", Color(1,1,1,1))


func _on_Exit_button_up():
	$Exit/ExitText.add_color_override("font_color", Color(0,0,0,1))


func _on_Exit_pressed():
	get_tree().quit()
	
func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_Speaker_pressed():
	music_on = !music_on
	if(music_on):
		$Speaker.texture_normal = speaker_on
		get_tree().get_nodes_in_group("bgm")[0].volume_db = -20
	else:
		$Speaker.texture_normal = speaker_off
		get_tree().get_nodes_in_group("bgm")[0].volume_db = -80

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = not visible
