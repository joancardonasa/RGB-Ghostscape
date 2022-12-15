extends CanvasLayer

onready var tooltip = $Tooltip
var loaded: bool = false

onready var _name = $Tooltip/MarginContainer/VBoxContainer/Name
onready var _text = $Tooltip/MarginContainer/VBoxContainer/Text
onready var _duration = $Tooltip/MarginContainer/VBoxContainer/Duration
var base_size: float

var _card_box
func _ready():
    #Hackiest way, we are in a jam
    yield(get_tree().create_timer(0.1), "timeout")
    base_size = tooltip.rect_size.y
    _card_box = Utils.get_ui_cardbox()
    _card_box.connect("CardBox_Enabled", self, "hide_tooltip")
    _load()


func _load():
    for card in _card_box.get_cards():
        card.connect("card_entered", self, "show_tooltip")
        card.connect("card_exited", self, "hide_tooltip")
    loaded = true

func _process(_delta):
    if tooltip.is_visible():
        tooltip.set_position(tooltip.get_global_mouse_position())

func show_tooltip(card):
    _set_card(card)
    tooltip.show()

func hide_tooltip(_card):
    tooltip.hide()

func _set_card(card):
    var data = card.card_data
    _name.text = data.name
    _text.text = data.tooltip
    var textSize = _text.get_font("font").get_string_size(data.tooltip)
    tooltip.rect_size.y = base_size + (textSize.y * _text.get_line_count())
    _duration.text = "%.1fs" % data.Duration
