extends Resource
class_name CardGreen

export(String) var name = "[Green] Default"
export(float) var Duration = 5.0
export(float) var SpeedMult = 2.0
export(Color, RGB) var col = Color(0,1,0)
export(bool) var reveal_enemies = false
export(bool) var reveal_pickups = false
export(bool) var reveal_platforms = true
export(Texture) var icon

var _cardManager

func set_card_manager(cardManager):
    _cardManager = cardManager

func Enter():
    _cardManager.emit_signal("Player_SpeedMult",true, SpeedMult)
    if(reveal_platforms): _cardManager.emit_signal("Platform_Reveal",true)

func Exit():
    _cardManager.emit_signal("Player_SpeedMult",false, SpeedMult)
    if(reveal_platforms): _cardManager.emit_signal("Platform_Reveal",false)
