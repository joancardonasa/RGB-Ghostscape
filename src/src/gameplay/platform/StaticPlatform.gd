extends StaticBody

onready var _collider = $CollisionShape
onready var _mesh = $MeshInstance

func set_enabled(enabled):
    _collider.disabled = !enabled
    _mesh.visible = enabled
