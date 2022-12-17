extends Resource

class_name CardGreenHeal

export(String) var name = "[Green] Heal"
export(String) var tooltip = "Heals 1 Hit, breaks on use"
export(float) var Duration = 2.0
export(float) var SpeedMult = 2.0
export(Color, RGB) var col = Color("#008143")
export(bool) var reveal_platforms = true
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Player_SpeedMult",true, SpeedMult)
    if(reveal_platforms): _cardManager.emit_signal("Platform_Reveal",true)
    _cardManager.emit_signal("Player_Heal", 1)

func Exit():
    _cardManager.emit_signal("Player_SpeedMult",false, SpeedMult)
    if(reveal_platforms): _cardManager.emit_signal("Platform_Reveal",false)
    _cardManager.remove_from_deck(self)