extends Node


onready var _platforms: Array = get_children()

func _ready():
    Utils.get_card_manager().connect("Platform_Reveal", self, "on_platform_reveal")
    for platform in _platforms:
        platform.set_enabled(false)

func on_platform_reveal(enabled: bool):
    var affected = _platforms if not enabled else Utils.choice(_platforms, int(ceil(_platforms.size() * 0.3)))
    for platform in affected:
        platform.set_enabled(enabled)