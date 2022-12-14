extends Node

export(Array, Resource) var StartDeck
export(int) var max_deck_size = 7
var deck : Array = []
var _next_draw: float

var current_card
onready var _ui_deck = Utils.get_ui_deck()

# Card Signals
#warning-ignore-all:unused_signal
signal Player_SpeedMult(enable, mult)
signal Player_Heal(amount)
signal Player_Invulnerable(enable)
signal Player_DamageMult(enable, mult)

signal Enemy_Reveal(enable)
signal Enemy_Stop(enable)

signal Platform_Reveal(enable)

signal Pickup_Reveal(enable)
signal Pickup_Delete()

# Deck Signals
signal Draw_Card(card, duration)

var is_in_rest: bool = true

var default_green = preload("res://data/cards/GreenCardDefault.tres")
var default_red = preload("res://data/cards/RedCardDefault.tres")
var default_blue = preload("res://data/cards/BlueCardDefault.tres")

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
    if is_in_rest:
        return
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
    if deck.size() < 3:
        var ncard
        if "Green" in card.name:
            ncard = default_green.duplicate()
        elif "Red" in card.name:
            ncard = default_red.duplicate()
        elif "Blue" in card.name:
            ncard = default_blue.duplicate()
        _ui_deck._add_card(ncard)
        add_to_deck(ncard, 0)



func _on_WaveManager_rest_started():
    is_in_rest = true


func _on_WaveManager_wave_started(_current_wave):
    is_in_rest = false
