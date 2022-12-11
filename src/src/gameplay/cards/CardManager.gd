extends Node

export(Array, Resource) var StartDeck

var deck : Array = []
var _next_draw: float
var _current_ind: int

var current_card


# Card Signals
#warning-ignore-all:unused_signal
signal Player_SpeedMult(enable, mult)
signal Player_AllowShoot(enable)
signal Enemy_Reveal(enable)
signal Platform_Reveal(enable)

# Deck Signals
signal Draw_Card(card, duration)

func _ready():
    deck = StartDeck.duplicate()
    for card in deck:
        card.set_card_manager(self)
    _current_ind = -1

func _draw_card():
    if(_current_ind >= 0):
        deck[_current_ind].Exit()
    _current_ind = (_current_ind + 1) % deck.size()

    current_card = deck[_current_ind]
    _next_draw = current_card.Duration
    current_card.Enter()
    emit_signal("Draw_Card", current_card, current_card.Duration)

func _physics_process(delta):
    if _next_draw > 0:
        _next_draw -= delta
    else:
        _draw_card()

func get_ordered_deck():
    if (_current_ind <= 0):
        return deck
    # Returns the deck in the order it will be drawn
    return deck.slice(_current_ind, deck.size()) + deck.slice(0, _current_ind - 1)
