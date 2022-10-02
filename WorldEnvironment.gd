extends WorldEnvironment


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time = OS.get_time()
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if (time.hour > 18 or time.hour < 6):
		pass
	else:
		environment = load('res://default_env.tres')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
