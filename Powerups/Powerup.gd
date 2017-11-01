extends Sprite

var powerup

var bombsTex = load("res://Powerups/powerupBomb.png")
var rangeTex = load("res://Powerups/powerupPower.png")
var speedTex = load("res://Powerups/powerupSpeed.png")

func _ready():
	randomize()
	powerup = randi() % 3
	print(powerup)
	if powerup == 0:
		set_texture(bombsTex)
	if powerup == 1:
		set_texture(rangeTex)
	if powerup == 2:
		set_texture(speedTex)
	if powerup == 3:
		pass


func activate(body):
	if body.is_in_group("player"):
		if powerup == 0:
			body.bombs += 1
		if powerup == 1:
			body.bombRange += 1
		if powerup == 2:
			body.moreRunMult(0.1)
		if powerup == 3:
			pass
		queue_free()