extends Area2D

var bombRange
var nextPos = Vector2()
var direction = Vector2()

var ogBomb

var nextTimer = Timer.new()


var shouldMakeNextFire = true

func _ready():
	self.set_global_pos(nextPos)
	
	#self.connect("body_enter", self, "stop", [ ], CONNECT_DEFERRED)
	nextTimer.connect("timeout", self, "makeNextFire", [], CONNECT_ONESHOT)
	self.add_child(nextTimer)
	nextTimer.set_wait_time(0.02)
	nextTimer.start()
	self.connect("body_enter", self, "destroy", [ ], CONNECT_ONESHOT)

func destroy(body):
	if body.is_in_group("tilemap"):
		shouldMakeNextFire = false
		nextTimer.stop()
		queue_free()
	elif body.is_in_group("box"):
		shouldMakeNextFire = false
		nextTimer.stop()
		print("Found box!")
		ogBomb.toBeDestroyed.append(body.get_parent())
	elif body.is_in_group("bomb") and body.get_parent() != ogBomb:
		body.get_parent().explode()
		shouldMakeNextFire = false
		nextTimer.stop()
		queue_free()
	elif body.is_in_group("player"):
		body.die()
	elif body.is_in_group("powerup"):
		body.get_parent().queue_free()
	#self.get_node("Fire Particle").set_self_opacity(1)

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