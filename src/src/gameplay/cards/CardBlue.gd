extends Resource

class_name CardBlue

export(float) var Duration = 5.0
export(Color, RGB) var col = Color(0, 0, 1)
export(bool) var reveal_enemies = false

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    pass

func Exit():
    pass
