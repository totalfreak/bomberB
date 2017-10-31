extends KinematicBody2D

var left  = Vector2(-1, 0)
var right = Vector2( 1, 0)
var up    = Vector2(0, -1)
var down  = Vector2(0,  1)

var hasBombed = false
var bombs = 1
var torchPos
var bombScene
onready var timer = Timer.new()

var health = 1

const MOVE_SPEED = 120
var run_mult = 1

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	

	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer)
	timer.start()

func _fixed_process(delta):

	#Shooting
	if Input.is_action_pressed("shoot") and !hasBombed and bombs > 0:
		shoot()
	
	#Reseting velocity
	var velocity = Vector2()
	
	#Moving left and right
	if Input.is_action_pressed("move_left"):
		velocity += left
		
	elif Input.is_action_pressed("move_right"):
		velocity += right
	
	#Moving up and down
	if Input.is_action_pressed("move_up"):
		velocity += up
	elif Input.is_action_pressed("move_down"):
		velocity += down
	
	velocity *= run_mult
	var motion = (velocity * MOVE_SPEED) * delta
	motion = move(motion)
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)


func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed():
		pass


func shoot():
	var bomb = load("res://Bomb/Bomb.tscn").instance()
	var explodeTimer = Timer.new()
	explodeTimer.connect("timeout", bomb, "explode")
	explodeTimer.set_wait_time(3.0)
	get_parent().add_child(bomb)
	bomb.add_child(explodeTimer)
	explodeTimer.start()
	
	bomb.set_pos(self.get_pos().snapped(Vector2(32, 32)))
	
	### Save this, will probably need for kicking power
	
	#var rigidbody_vector = (get_global_mouse_pos() - torchPos.get_global_pos()).normalized()
	#bullet.apply_impulse(bullet.get_pos(), rigidbody_vector*shootSpeed)
	hasBombed = true
	#bombs -= 1
	timer.set_wait_time( 0.5 )
	timer.start()

func _on_timer_timeout():
	hasBombed = false


func damage(dmg):
	health-=dmg
	if health <= 0:
		die()

func die():
	#self.queue_free()
	pass