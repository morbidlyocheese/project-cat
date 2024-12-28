extends Pickups
class_name Gem

@export var XP : float

func activate():
	super.active()
	prints("+" + str(XP) + "XP")
	player_reference.gain_XP(XP)
