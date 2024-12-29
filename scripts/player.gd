extends CharacterBody2D

var speed : float = 150
var health : float = 100:
	set(value):
		health = value
		%healthbar.value = value

var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = INF

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
		if level >= 5:
			%XP.max_value = 40
		elif level >= 10:
			%XP.max_value = 70

func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
		print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
		
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)
	check_XP()

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

func take_damage(amount):
	health -= amount
	print(amount)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_timer_timeout():
	%collision.set_deferred('disabled', true)
	%collision.set_deferred('disabled', false)

# gain xp
func gain_XP(amount):
	XP += amount
	total_XP += amount

# checks xp & increases level
func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1

func _on_magnet_area_entered(area):
	if area.has_method("follow"):
		area.follow(self)
