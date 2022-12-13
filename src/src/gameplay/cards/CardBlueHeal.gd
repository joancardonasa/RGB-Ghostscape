extends Resource

class_name CardBlueHeal

export(String) var name = "[Blue] Heal"
export(String) var tooltip = "Heals 1 Hit, Breaks on use"
export(float) var Duration = 5.0
export(Color, RGB) var col = Color(0, 0, 1)
export(bool) var reveal_enemies = false
export(bool) var reveal_pickups = true
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Pickup_Reveal", true)
    _cardManager.emit_signal("Player_Heal", 1)

func Exit():
    _cardManager.emit_signal("Pickup_Reveal", false)
    _cardManager.emit_signal("Pickup_Delete")
