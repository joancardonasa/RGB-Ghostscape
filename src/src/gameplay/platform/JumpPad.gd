extends Area

class_name JumpPad

export var force: float = 20

onready var _player = Utils.get_player()
onready var _collider = $CollisionShape
onready var _mesh = $MeshInstance

func _on_JumpArea_body_entered(body):
    if body == _player:
        _player.boost(Vector3(0, force, 0))

func set_enabled(enabled):
    _collider.disabled = !enabled
    _mesh.visible = enabled
