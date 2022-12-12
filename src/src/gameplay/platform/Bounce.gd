extends Area

export var force: float = 50
export var jump: float = 5
var boost_vec: Vector3

onready var _player = Utils.get_player()
onready var _collider = $CollisionShape
onready var _mesh = $MeshInstance

func _ready():
    boost_vec = -get_global_transform().basis.z * force
    boost_vec.y = jump


func _on_JumpArea_body_entered(body):
    if body == _player:
        _player.boost(boost_vec)

func set_enabled(enabled):
    _collider.disabled = !enabled
    _mesh.visible = enabled
