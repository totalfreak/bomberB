extends RigidBody2D

func _ready():
	
	pass


func explode():
	print("Boom!")
	queue_free()