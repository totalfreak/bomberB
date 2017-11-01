extends AnimatedSprite

onready var fireScene = preload("res://Bomb/Fire.tscn")

var bombRange

var right 
var left
var up
var down

var toBeDestroyed = []

var hasExploded = false

var player
var playerPath

onready var dieTimer = Timer.new()

func _ready():
	right = self.get_node("Right")
	left = self.get_node("Left")
	up = self.get_node("Up")
	down = self.get_node("Down")
	playerPath = player.get_path()
	dieTimer.connect("timeout", self, "die", [], CONNECT_ONESHOT)
	add_child(dieTimer)
	dieTimer.set_wait_time(1.0)
	pass


func explode():
	if !hasExploded:
		hasExploded = true
		var startPos = self.get_global_pos()
		
		var ownFire = fireScene.instance()
		add_child(ownFire)
		ownFire.set_global_pos(Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32)))
		ownFire.nextPos = Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32))
		ownFire.direction = Vector2(0, 0)
		ownFire.bombRange = 1
		ownFire.ogBomb = self
	
		startPos = self.get_global_pos()
		startPos.x -= 64
	
	
		### Left firing bomb thing
		var fire = fireScene.instance()
		left.add_child(fire)
		#fire.connect("body_enter", fire, "destroy", [ ], CONNECT_DEFERRED)
		fire.set_global_pos(Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32)))
		fire.nextPos = Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32))
		fire.direction = Vector2(-64, 0)
		fire.bombRange = self.bombRange
		fire.ogBomb = self
		
		startPos = self.get_global_pos()
		startPos.x += 64
		
		### Right firing bomb thing
		var rightFire = fireScene.instance()
		right.add_child(rightFire)
		#fire.connect("body_enter", fire, "destroy", [ ], CONNECT_DEFERRED)
		rightFire.set_global_pos(Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32)))
		rightFire.nextPos = Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32))
		rightFire.direction = Vector2(64, 0)
		rightFire.bombRange = self.bombRange
		rightFire.ogBomb = self
		
		### Up firing bomb thing
		startPos = self.get_global_pos()
		startPos.y -= 64
		var upFire = fireScene.instance()
		up.add_child(upFire)
		#fire.connect("body_enter", fire, "destroy", [ ], CONNECT_DEFERRED)
		upFire.set_global_pos(Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32)))
		upFire.nextPos = Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32))
		upFire.direction = Vector2(0, -64)
		upFire.bombRange = self.bombRange
		upFire.ogBomb = self
		
		### Down firing bomb thing
		startPos = self.get_global_pos()
		startPos.y += 64
		var downFire = fireScene.instance()
		down.add_child(downFire)
		#fire.connect("body_enter", fire, "destroy", [ ], CONNECT_DEFERRED)
		downFire.set_global_pos(Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32)))
		downFire.nextPos = Vector2(startPos.x, startPos.y).snapped(Vector2(32, 32))
		downFire.direction = Vector2(0, 64)
		downFire.bombRange = self.bombRange
		downFire.ogBomb = self
		
		print("Boom!")
		set_self_opacity(0)
		dieTimer.start()



func die():
	if get_parent().has_node(playerPath):
		player.bombs += 1
		for box in toBeDestroyed:
			box.destroy()
	queue_free()