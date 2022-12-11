extends Control


var UI_Card = preload("res://src/UI/UI_Card.tscn")
onready var _card_container = $CardContainer
var _card_manager
var _deck = {}
var _preview_card: Control
var _preview_pos: int = -1

signal card_added(card, idx)


func _ready():
    _card_manager = Utils.get_card_manager()
    _clear_deck()
    _card_manager.connect("Draw_Card",self, "_draw_card")
    _preview_card = UI_Card.instance()

    _set_deck(_card_manager.deck)

func _clear_deck():
    for card in _card_container.get_children():
        card.queue_free()

func _set_deck(cards: Array):
    for card in cards:
        var card_instance = UI_Card.instance()
        _card_container.add_child(card_instance)
        card_instance.set_card(card)
        _deck[card.get_instance_id()] = card_instance

func _draw_card(card: Resource, duration: float):
    var card_instance = _deck[card.get_instance_id()]
    card_instance.activate(duration)
    # Hacky way to wait the anim time for the node to deactivate
    yield(get_tree().create_timer(0.75), "timeout")
    _reorder_deck(_card_manager.get_ordered_deck())

func _reorder_deck(newOrder):
    for child in _card_container.get_children():
        if child != _preview_card:
            _card_container.remove_child(child)
    for card in newOrder:
        _card_container.add_child(_deck[card.get_instance_id()])
    if(_preview_pos != -1):
        _card_container.move_child(_preview_card, _preview_pos)
        
func can_drop_data(position: Vector2, data):
    var can_drop = data is Node and data.is_in_group("DRAGGABLE")
    if not can_drop:
        return false
    var idx = _idx_from_pos(position)
    if idx != _preview_pos:
        if _preview_pos == -1:
            _card_container.add_child(_preview_card)
            _preview_card.set_card(data.card_data)
        _card_container.move_child(_preview_card, idx)
        _preview_pos = idx
    return can_drop

func drop_data(position: Vector2, data):
    _remove_preview()
    var card_data = data.card_data.duplicate()
    emit_signal("card_added", card_data, _idx_from_pos(position))
    _add_card(card_data)

func _idx_from_pos(pos: Vector2) -> int:
    var idx = 0
    for child in _card_container.get_children():
        if pos.y < (child.get_position().y + (child.get_size().y/2)):
            return idx
        idx += 1
    return idx

func _on_UI_Deck_mouse_exited():
    _remove_preview()

func _remove_preview():
    if _preview_pos!= -1:
        _card_container.remove_child(_preview_card)
        _preview_pos = -1

func _add_card(card_data: Resource):
    var ncard = UI_Card.instance()
    _card_container.add_child(ncard)
    ncard.set_card(card_data)
    _deck[card_data.get_instance_id()] = ncard
    _reorder_deck(_card_manager.get_ordered_deck())
    
