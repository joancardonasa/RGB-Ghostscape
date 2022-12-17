extends Particles

onready var death_sfx : AudioStreamPlayer3D = $DeathSFX

func _ready():
    emitting = true
    death_sfx.play()

func _on_DeathTimer_timeout():
    queue_free()
