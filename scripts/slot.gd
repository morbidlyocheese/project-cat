extends PanelContainer

@export var item : Weapon:
	set(value):
		item = value
		$TextureRect.texture = value.texture
		$cooldown.wait_time = value.cooldown
		item.slot = self

func _on_cooldown_timeout():
	if item: 
		$cooldown.wait_time = item.cooldown
		item.activate(owner, owner.nearest_enemy, get_tree())
