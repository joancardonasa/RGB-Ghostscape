extends Resource
class_name CardRedStop

export(String) var name = "[Red] Stop Enemies"
export(String) var tooltip = "Freezes enemies"
export(float) var Duration = 5.0
export(Color, RGB) var col = Color("#a50048")
export(bool) var reveal_enemies = true
export(bool) var stop_enemies = true
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Enemy_Reveal", true)
    _cardManager.emit_signal("Enemy_Stop", true)

func Exit():
    _cardManager.emit_signal("Enemy_Reveal", false)
    _cardManager.emit_signal("Enemy_Stop", false)