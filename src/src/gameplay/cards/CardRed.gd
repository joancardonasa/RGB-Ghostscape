extends Resource
class_name CardRed

export(String) var name = "[Red] Default"
export(String) var tooltip = ""
export(float) var Duration = 5.0
export(Color, RGB) var col = Color("#a50048")
export(bool) var reveal_enemies = true
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Enemy_Reveal", true)

func Exit():
    _cardManager.emit_signal("Enemy_Reveal", false)
