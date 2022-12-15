extends Node

export(Array, Resource) var StartDeck

var deck : Array = []
var _next_draw: float

var current_card
onready var _ui_deck = Utils.get_ui_deck()

# Card Signals
#warning-ignore-all:unused_signal
signal Player_SpeedMult(enable, mult)
signal Player_AllowShoot(enable)

signal Enemy_Reveal(enable)
signal Platform_Reveal(enable)

signal Pickup_Reveal(enable)
signal Pickup_Delete()

signal Player_Heal(amount)
# Deck Signals
signal Draw_Card(card, duration)

func _ready():
    deck = []
    for card in StartDeck:
        var new_card = card.duplicate()
        new_card.set_card_manager(self)
        deck.append(new_card)
    _ui_deck.connect("card_added", self, "add_to_deck")

func _draw_card():
    current_card = deck[0]
    _next_draw = current_card.Duration
    current_card.Enter()

    emit_signal("Draw_Card", current_card, current_card.Duration)

func push_card():
    if(current_card != null):
        current_card.Exit()
        deck.push_back(deck.pop_front())

func _physics_process(delta):
    if _next_draw > 0:
        _next_draw -= delta
    else:
        push_card()
        _draw_card()

func add_to_deck(card: Resource, idx: int):
    card.set_card_manager(self)
    deck.insert(idx, card)

func remove_from_deck(card: Resource):
    deck.erase(card)
