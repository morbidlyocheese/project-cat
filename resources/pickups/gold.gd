extends Pickups
class_name Gold

@export var gold : int = 5

func activate():
	super.active()
	player_reference.gain_gold(gold)
