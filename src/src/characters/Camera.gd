extends Camera

var camera_shake_intensity: float = 0.0

var camera_shake_duration: float = 0.0
var camera_shake_time_left: float = 0.0


enum Type {
    RANDOM,
    SINE,
}
var camera_shake_type = Type.RANDOM


func shake(intensity: float, duration: float, type = Type.RANDOM):
    # Maybe too much?
#    if not Settings.data.screenshake:
#        return
    if intensity > camera_shake_intensity and duration > camera_shake_time_left:
        camera_shake_intensity = intensity
        camera_shake_duration = duration
        camera_shake_time_left = camera_shake_duration
        camera_shake_type = type

func _process(delta):
    var _offset = Vector2.ZERO
    if camera_shake_time_left <= 0:
        _offset = Vector2.ZERO
        camera_shake_intensity = 0
        camera_shake_time_left = 0
        return

    camera_shake_time_left = camera_shake_time_left - delta

    if camera_shake_type == Type.RANDOM:
        var damping = ease(camera_shake_time_left / camera_shake_duration, 1)
        _offset = Vector2(
            rand_range(camera_shake_intensity, -camera_shake_intensity) * damping,
            rand_range(camera_shake_intensity, -camera_shake_intensity) * damping)

    if camera_shake_type == Type.SINE:
        _offset = Vector2(
            sin(OS.get_ticks_msec() * 0.03),
            sin(OS.get_ticks_msec() * 0.07)
        )

    h_offset = _offset[0]
    v_offset = _offset[1]
