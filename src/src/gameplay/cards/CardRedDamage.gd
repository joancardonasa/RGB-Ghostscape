extends Resource
class_name CardRedDamage

export(String) var name = "[Red] Double Damage"
export(String) var tooltip = "Doubles damage"
export(float) var Duration = 5.0
export(float) var damage_multiplier = 2.0
export(bool) var reveal_enemies = true
export(Color, RGB) var col = Color("#a50048")
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Enemy_Reveal", true)
    _cardManager.emit_signal("Player_DamageMult", true, damage_multiplier)

func Exit():
    _cardManager.emit_signal("Enemy_Reveal", false)
    _cardManager.emit_signal("Player_DamageMult", false, damage_multiplier)