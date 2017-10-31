extends Sprite

onready var boxScene = preload("res://Box1.tscn")
onready var map = get_node("TileMap")

func _ready():
	print("Shit")
	var box = boxScene.instance()
	box.set_global_pos(get_global_pos())
	get_tree().get_root().add_child(box)
	self.queue_free()
	pass
