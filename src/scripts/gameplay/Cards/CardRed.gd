extends Resource
class_name CardRed

export(float) var Duration = 5.0
export(Color, RGB) var col = Color(1, 0, 0)

var _cardManager

func set_card_manager(cardManager):
	_cardManager = cardManager

func Enter():
	_cardManager.emit_signal("Card_Color",col)

func Exit():
	pass
