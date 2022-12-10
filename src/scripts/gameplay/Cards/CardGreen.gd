extends Resource
class_name CardGreen

export(float) var Duration = 5.0
export(float) var SpeedMult = 2.0
var _cardManager

func set_card_manager(cardManager):
	_cardManager = cardManager

func Enter():
	_cardManager.emit_signal("Player_SpeedMult",true, SpeedMult)

func Exit():
	_cardManager.emit_signal("Player_SpeedMult",false, SpeedMult)
