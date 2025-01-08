extends Sprite2D

var frame_counter = 0
var separation : float
var health : float = 10:
	set(value):
		health = value
		if health < 0:
			drop_item()
			
@onready var player_referene = get_tree().current_scene.find_child("player")
var drop_node = preload("res://scenes/pickups.tscn")
@export var drops : Array[Pickups]

func _physics_process(_delta):
	frame_counter += 1
	if frame_counter >= 6:
		frame_counter = 0
		frame = (frame + 1) % (hframes * vframes)

	separation = (player_referene.position - position).length()
	if separation < player_referene.nearest_enemy_distance:
		player_referene.nearest_enemy = self

func take_damage(amount = 1):
	health -= amount
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(3, 0.25, 0.25), 0.2)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 0.2)
	
	tween.bind_node(self)

func drop_item():
	var item = drops.pick_random()
	
	var item_to_drop = drop_node.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_referene
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
	queue_free()
	
