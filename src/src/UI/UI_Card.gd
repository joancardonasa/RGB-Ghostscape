extends Control

export(int) var grow_size = 60
var cardData
var timer = 0

onready var time_label: Label = $UI_Card/MarginContainer/HBoxContainer/TimeLabel
onready var icon_rect: TextureRect = $UI_Card/MarginContainer/HBoxContainer/Control/Icon
onready var ui_card: ColorRect = $UI_Card

func set_card(card: Resource):
    cardData = card
    ui_card.color = cardData.col
    icon_rect.texture = cardData.icon
    _set_active(false)

func activate(duration: float):
    timer = duration
    _set_active(true)
    time_label.text = "%.1f" % timer

func _process(delta):
    if timer > 0:
        time_label.text = "%.1f" % timer
        timer -= delta
        if timer <= 0:
            _set_active(false)
            timer = 0

func _set_active(enabled: bool, anim_time: float = 0.75):
    time_label.set_visible(enabled)
    var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    if enabled:
        tween.tween_property(ui_card, "margin_left", -1.0 * grow_size, anim_time)
        ui_card.color = cardData.col
    else:
        tween.tween_property(ui_card, "margin_left", 0.0, anim_time)
        ui_card.color = cardData.col - Color(0, 0, 0, 0.2)
    
        
    
