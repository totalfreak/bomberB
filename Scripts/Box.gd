extends Sprite

onready var powerupScene = preload("res://Powerups/Powerup.tscn")

var shouldSpawnPowerUp = false

func _ready():
	randomize()
	if rand_range(0, 3) < 1:
		shouldSpawnPowerUp = true
	pass


func destroy():
	if shouldSpawnPowerUp:
		var powerup = powerupScene.instance()
		get_tree().get_root().add_child(powerup)
		powerup.set_global_pos(get_global_pos()+ Vector2(32, 32))
		powerup.get_child(0).connect("body_enter", powerup, "activate", [], CONNECT_ONESHOT)
	queue_free()