extends CanvasLayer

onready var tooltip = $Tooltip
var loaded: bool = false

func _ready():
    #Hackiest way, we are in a jam
    yield(get_tree().create_timer(0.1), "timeout")
    _load()


func _load():
    for card in Utils.get_ui_cardbox().get_cards():
        card.connect("card_entered", self, "show_tooltip")
        card.connect("card_exited", self, "hide_tooltip")
    loaded = true

func _process(_delta):
    if tooltip.is_visible():
        tooltip.set_position(tooltip.get_global_mouse_position())

func show_tooltip(card):
    _set_card(card)
    tooltip.show()

func hide_tooltip(card):
    tooltip.hide()

func _set_card(card):
    pass
