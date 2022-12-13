extends Control


export(int) var locked_cards = 3


var UI_Card = preload("res://src/UI/UI_Card.tscn")
onready var _card_container = $CardContainer
var _card_manager
var _deck = {}
var _preview_card: Control
var _preview_pos: int = -1
onready var _move_preview_timer: Timer = $MovePreview

signal card_added(card, idx)
signal card_removed(card)


func _ready():
    _card_manager = Utils.get_card_manager()
    _clear_deck()
    _card_manager.connect("Draw_Card",self, "_draw_card")
    _preview_card = UI_Card.instance()
    _preview_card.get_node("Background").margin_right = -50
    _preview_card.get_node("Background").margin_left = -50
    _preview_card.grow_size = 0
    
    for card in _card_manager.deck:
        _add_card(card)

func _clear_deck():
    for card in _card_container.get_children():
        card.queue_free()

func _draw_card(card: Resource, duration: float):
    var card_instance = _deck[card.get_instance_id()]
    card_instance.activate(duration)
    _reorder_deck()

func _reorder_deck():
    for child in _card_container.get_children():
        if child != _preview_card:
            _card_container.remove_child(child)
    for card_idx in _card_manager.deck.size():
        var nchild = _deck[_card_manager.deck[card_idx].get_instance_id()]
        _card_container.add_child(nchild)
        nchild.locked = card_idx < locked_cards
    if(_preview_pos != -1):
        _card_container.move_child(_preview_card, _preview_pos)
        
func can_drop_data(position: Vector2, data):
    var idx = _idx_from_pos(position)
    var can_drop = data is Node and data.is_in_group("DRAGGABLE") and idx >= locked_cards
    if not can_drop:
        return false
    if not _move_preview_timer.is_stopped():
        return can_drop
    if idx != _preview_pos:
        if _preview_pos == -1:
            _card_container.add_child(_preview_card)
            _preview_card.set_card(data.card_data)
        _card_container.move_child(_preview_card, idx)
        _preview_pos = idx
        _move_preview_timer.start()
    return can_drop

func drop_data(position: Vector2, data):
    _remove_preview()                   
    var card_data = data.card_data.duplicate()
    emit_signal("card_added", card_data, _idx_from_pos(position))
    _add_card(card_data)
    _reorder_deck()
    
func _on_UI_Deck_mouse_exited():
    if(get_viewport().get_mouse_position().x < rect_position.x):
        _remove_preview()
    
func _idx_from_pos(pos: Vector2) -> int:
    var idx = 0
    for child in _card_container.get_children():
        if child == _preview_card:
            continue
        if pos.y < child.rect_position.y + child.rect_size.y:
            return idx
        idx += 1
    return idx

func _remove_preview():
    if _preview_pos!= -1:
        _card_container.remove_child(_preview_card)
        _preview_pos = -1

func _add_card(card_data: Resource):
    var ncard = UI_Card.instance()
    _card_container.add_child(ncard)
    ncard.set_card(card_data)
    _deck[card_data.get_instance_id()] = ncard
    ncard.connect("lifted", self, "_on_card_lifted")

func _on_card_lifted(card):
    _card_manager.remove_from_deck(card.card_data)
    _card_container.remove_child(card)
    _deck.erase(card.card_data.get_instance_id())
    _reorder_deck()
    emit_signal("card_removed", card.card_data)
