extends Node


onready var _platforms: Array = get_children()
export var perc_enable: float = 0.75
var _revealed: bool = false

func _ready():
    Utils.get_card_manager().connect("Platform_Reveal", self, "on_platform_reveal")
    for platform in _platforms:
        platform.set_enabled(false)

func on_platform_reveal(enabled: bool):
    if _revealed == enabled:
        return
    _revealed = enabled
    var affected = _platforms if not enabled else Utils.choice(_platforms, int(ceil(_platforms.size() * perc_enable)))
    for platform in affected:
        platform.set_enabled(enabled)
