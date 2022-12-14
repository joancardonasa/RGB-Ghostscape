extends Resource

class_name CardBlue

export(String) var name = "[Blue] Default"
export(String) var tooltip = ""
export(float) var Duration = 5.0
export(Color, RGB) var col = Color("#0e7bae")
export(bool) var reveal_enemies = false
export(bool) var reveal_pickups = true
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Pickup_Reveal", true)

func Exit():
    _cardManager.emit_signal("Pickup_Reveal", false)
    _cardManager.emit_signal("Pickup_Delete")
