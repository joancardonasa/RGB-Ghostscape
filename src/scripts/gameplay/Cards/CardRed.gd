extends Resource
class_name CardRed

export(float) var Duration = 5.0
var _cardManager

func set_card_manager(cardManager):
	_cardManager = cardManager

func Enter():
	_cardManager.emit_signal("Player_AllowShoot",true)

func Exit():
	_cardManager.emit_signal("Player_AllowShoot",false)
