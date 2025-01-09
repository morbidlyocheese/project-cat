extends PanelContainer

@export var item : Weapon:
	set(value):
		item = value
		$TextureRect.texture = value.icon
		$cooldown.wait_time = value.cooldown
		item.slot = self
		
func _physics_process(delta):
	if item != null and item.has_method("update"):
		item.update(delta)

func _on_cooldown_timeout():
	if item: 
		$cooldown.wait_time = item.cooldown
		item.activate(owner, owner.nearest_enemy, get_tree())
