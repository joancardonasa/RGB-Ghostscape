extends Resource
class_name CardGreen

export(float) var Duration = 5.0
export(float) var SpeedMult = 2.0

func Enter():
	emit_signal("Player_SpeedMult", true, SpeedMult)

func Exit():
	emit_signal("Player_SpeedMult", false, SpeedMult)
