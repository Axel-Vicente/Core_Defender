extends Sprite

var anim = 0 #El frame
var time = 0.2 #Segundos de cambio de frame

func _physics_process(delta):
	anim += (delta/time)*2
	if anim > 7: #Cantidad de frames del sprite
		anim = 0
	set_frame(int(anim))
