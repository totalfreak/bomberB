extends Area2D

var bombRange
var nextPos = Vector2()
var direction = Vector2()

var ogBomb

var nextTimer = Timer.new()


var shouldMakeNextFire = true

func _ready():
	self.set_global_pos(nextPos)
	self.connect("body_enter", self, "destroy", [ ], CONNECT_DEFERRED)
	#self.connect("body_enter", self, "stop", [ ], CONNECT_DEFERRED)
	nextTimer.connect("timeout", self, "makeNextFire", [], CONNECT_ONESHOT)
	self.add_child(nextTimer)
	nextTimer.set_wait_time(0.02)
	nextTimer.start()

func destroy(body):
	print(body)
	if !body.is_in_group("player") and body.get_name() != "TileMap":
		shouldMakeNextFire = false
		nextTimer.stop()
		print(body.get_name())
		ogBomb.toBeDestroyed.append(body.get_parent())
	elif body.get_name() == "TileMap":
		shouldMakeNextFire = false
		nextTimer.stop()
		queue_free()
	else:
		body.die()

func makeNextFire():
	bombRange -= 1
	if shouldMakeNextFire and bombRange > 0:
		var fire = load("res://Bomb/Fire.tscn").instance()
		fire.ogBomb = self.ogBomb
		get_parent().add_child(fire)
		fire.set_global_pos(nextPos+direction)
		fire.direction = self.direction
		fire.nextPos = nextPos + direction
		fire.bombRange = self.bombRange
		print("New bomb!")

func stop():
	print("Shit")