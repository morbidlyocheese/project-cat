extends CharacterBody2D

var move_speed : float = 150
var health : float = 400:
	set(value):
		health = max(value, 0)
		%healthbar.value = value
var max_hp : float = 100 :
	set(value):
		max_hp = value
		%healthbar.max_value = value
var recovery : float = 0
var armor : float = 0
var might : float = 1.5
var area : float = 0
var magnet : float = 0:
	set(value):
		magnet = value
		%magnet_coll.shape.radius = 50 + value
var growth : float = 1

var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = 150 + area

var gold : int = 0:
	set(value):
		gold = value
		%gold.text = str(value) + "g"

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var level : int = 1:
	set(value):
		level = value
		%Level.text = "lvl " + str(value)
		%Options.show_option()
		
		# leveling mechanic: max value needed after certain level achieved
		if level >= 3:
			%XP.max_value = 20
		elif level >= 7:
			%XP.max_value = 40

func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
		print(nearest_enemy.name)
	else:
		nearest_enemy_distance = 150 + area
		nearest_enemy = null
		
	# BUG
	# TODO
	# automoves player; disables WASD/arrows
	# make this a control option
	# 
	#if global_position.distance_to(get_global_mouse_position()) < 10: return
	#
	#var direction = (get_global_mouse_position() - global_position).normalized()
	#
	#if direction:
		#velocity = direction * speed
	#else:
		#velocity = Vector2.ZERO
	#move_and_slide()
		
	velocity = Input.get_vector("left","right","up","down") * move_speed
	move_and_collide(velocity * delta)
	check_XP()
	health += recovery * delta

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

func take_damage(amount):
	health -= max(amount - armor, 0)
	print(amount)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_timer_timeout():
	%collision.set_deferred('disabled', true)
	%collision.set_deferred('disabled', false)

# gain xp
func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth

# checks xp & increases level
func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1

func _on_magnet_area_entered(areaa):
	if areaa.has_method("follow"):
		areaa.follow(self)

func gain_gold(amount):
	gold += amount
	
func open_chest():
	$ui/chest.open()
