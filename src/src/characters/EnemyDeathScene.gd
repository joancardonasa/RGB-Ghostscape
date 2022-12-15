extends Particles


func _ready():
    emitting = true


func _on_DeathTimer_timeout():
    queue_free()
