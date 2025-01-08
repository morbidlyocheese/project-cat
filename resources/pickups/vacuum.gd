extends Pickups
class_name PickupMagnet

func activate():
	super.active()
	player_reference.get_tree().call_group("pickups", "follow", player_reference, true)
