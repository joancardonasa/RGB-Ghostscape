# Author Kamyab Nazari - 2021

extends Node

class_name Stats

export var max_HP = 10

onready var current_HP = max_HP

signal died_signal
signal hp_updated(new_hp)

func _ready():
    pass

func take_hit(damage):
    current_HP -= damage
    emit_signal("hp_updated", current_HP)
    if current_HP <= 0:
        die()

func heal(amount: int):
    current_HP = clamp(current_HP + amount, 0, max_HP)
    emit_signal("hp_updated", current_HP)

func die():
    emit_signal("died_signal")
