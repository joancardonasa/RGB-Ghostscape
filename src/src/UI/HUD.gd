extends CanvasLayer


onready var speed_lines = $SpeedLines

var card_manager = null

func _ready():
    var card_manager = Utils.get_card_manager()
    card_manager.connect("Player_SpeedMult", self, "_on_Card_SpeedMult")

func _on_Card_SpeedMult(enable : bool, _mult : float):
    activate_speed_lines(enable)

func activate_speed_lines(enable: bool):
    speed_lines.emitting = enable
