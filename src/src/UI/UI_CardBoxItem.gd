extends ColorRect

export(Resource) var card_data
export(int) var count = 1
var previewCount = 1

onready var _label_count = $Label

func _ready():
    var ui_deck = Utils.get_ui_deck()
    ui_deck.connect("card_added", self, "_deck_on_card_added")
    ui_deck.connect("card_removed", self, "_deck_on_card_removed")
    add_to_group("DRAGGABLE")
    _set_card(card_data, count)

func get_drag_data(_position: Vector2):
    if(count<=0):
        return
    set_drag_preview(_preview_drag())
    previewCount = count - 1 if count < 10 else 10
    _reflect_count(previewCount)
    return self

func _set_card(card: Resource, card_count: int):
    card_data = card
    color = card_data.col
    count = card_count
    _reflect_count(count)
    
func _preview_drag():
    var preview = ColorRect.new()
    preview.rect_size = rect_size * 0.35
    preview.color = color
    preview.rect_rotation = 45
    preview.connect("tree_exiting", self, "_end_drag")
    return preview
    
func _end_drag():
    _reflect_count(count)


func _reflect_count(new_count: int):
    # Do not decrease or add cards once we get to 10
    if new_count >= 10:
        _label_count.text = ""
    else:
        _label_count.text = str(new_count)
    if new_count == 0:
        var gvalue: float = card_data.col.v / 2
        color = Color(gvalue,gvalue,gvalue,1)
    else:
        color = card_data.col

func _deck_on_card_added(data, _position: int):
    if data.name == card_data.name:
        count = previewCount
        _reflect_count(count)
    
func _deck_on_card_removed(data):   
    if data.name == card_data.name:
        count +=1
        _reflect_count(count)
