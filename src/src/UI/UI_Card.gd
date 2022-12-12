extends Control

export(int) var grow_size = 60
var card_data
var timer = 0

onready var time_label: Label = $UI_Card/MarginContainer/HBoxContainer/TimeLabel
onready var icon_rect: TextureRect = $UI_Card/MarginContainer/HBoxContainer/Control/Icon
onready var ui_card: ColorRect = $UI_Card

signal lifted

func _ready():
    ui_card.color = Color(0,0,0,0)
    add_to_group("DRAGGABLE")

func set_card(card: Resource):
    card_data = card
    ui_card.color = card_data.col
    icon_rect.texture = card_data.icon
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
        ui_card.color = card_data.col
    else:
        tween.tween_property(ui_card, "margin_left", 0.0, anim_time)
        ui_card.color = card_data.col - Color(0, 0, 0, 0.2)
    
func get_drag_data(_position: Vector2):
    set_drag_preview(_preview_drag())
    emit_signal("lifted",self)
    return self

func _preview_drag():
    var preview = ColorRect.new()
    preview.rect_size = Vector2(200,100) * 0.35
    preview.color = card_data.col
    preview.rect_rotation = 45
    return preview
