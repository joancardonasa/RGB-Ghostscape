extends ColorRect
var cardData
var timer = 0

onready var time_label: Label = $MarginContainer/HBoxContainer/TimeLabel

func _ready():
    time_label.set_visible(false)

func set_card(card: Resource):
    cardData = card
    self.color = cardData.col

func activate(duration: float):
    time_label.set_visible(true)
    time_label.text = "%.1f" % timer
    timer = duration

func _process(delta):
    if timer > 0:
        time_label.text = "%.1f" % timer
        timer -= delta
        if timer <= 0:
            time_label.set_visible(false)
            timer = 0
