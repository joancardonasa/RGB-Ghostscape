extends "res://src/gameplay/Pickups/Pickup.gd"
class_name CardPickup

export(Resource) var card_type
export(int) var card_amount = 1

onready var sprite = $Sprite3D

func _ready():
    sprite.modulate = card_type.col

