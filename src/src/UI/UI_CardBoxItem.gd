extends Control

export(Resource) var card_data
export(int) var count = 1
var previewCount = 1

onready var _label_count: Label = $Background/MarginContainer/VBoxContainer/Label
onready var _background: Button = $Background
onready var _icon: TextureRect = $Background/MarginContainer/VBoxContainer/Icon
onready var _pick_up_sfx: AudioStreamPlayer = $PickUpSFX

signal card_entered(card)
signal card_exited(card)

func _ready():
    var ui_deck = Utils.get_ui_deck()
    ui_deck.connect("card_added", self, "_deck_on_card_added")
    ui_deck.connect("card_removed", self, "_deck_on_card_removed")
    add_to_group("DRAGGABLE")
    _set_card(card_data, count | 0)
    connect("mouse_entered", self, "_on_UI_CardBoxItem_mouse_entered")
    connect("mouse_exited", self, "_on_UI_CardBoxItem_mouse_exited")

func get_drag_data(_position: Vector2):
    if(count<=0):
        return
    set_drag_preview(_preview_drag())
    previewCount = count - 1 if count < 10 else 10
    _reflect_count(previewCount)
    Sound.play(_pick_up_sfx)
    return self

func _set_card(card: Resource, card_count: int):
    card_data = card
    _background.self_modulate = card_data.col
    count = card_count
    _icon.texture = card_data.icon
    _reflect_count(count)
    
func _preview_drag():
    var preview = ColorRect.new()
    preview.rect_size = rect_size * 0.35
    preview.color = _background.self_modulate
    preview.rect_rotation = 45
    preview.connect("tree_exiting", self, "_end_drag")
    return preview
    
func _end_drag():
    _reflect_count(count)

func add_card(amount: int):
    count += amount
    previewCount += amount
    _reflect_count(previewCount)


func _reflect_count(new_count: int):
    # Do not decrease or add cards once we get to 10
    if new_count >= 10:
        _label_count.text = ""
    else:
        _label_count.text = str(new_count)
    if new_count == 0:
        var gvalue: float = card_data.col.v / 2
        _background.self_modulate = Color(gvalue,gvalue,gvalue,1)
    else:
        _background.self_modulate = card_data.col

func _deck_on_card_added(data, _position: int):
    if data.name == card_data.name:
        count = previewCount
        _reflect_count(count)
    
func _deck_on_card_removed(data):   
    if data.name == card_data.name:
        count +=1
        _reflect_count(count)

func _on_UI_CardBoxItem_mouse_exited():
    emit_signal("card_exited", self)

func _on_UI_CardBoxItem_mouse_entered():
    if count > 0: 
        emit_signal("card_entered", self)
