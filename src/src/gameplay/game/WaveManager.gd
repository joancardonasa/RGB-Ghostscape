extends Node

onready var wave_timer = $WaveTimer
onready var rest_timer = $RestTimer

# Seconds
export(float) var wave_time_limit = 60
export(float) var rest_time_limit = 10

var current_wave: int = 0
var last_wave: int = 10

var time: float = 0
var timer_on = false

enum WAVE_STATE {
    WAVE,
    REST
}

var current_state

var hud = null

signal wave_started(current_wave)
signal rest_started()

func _ready():
    wave_timer.wait_time = wave_time_limit
    rest_timer.wait_time = rest_time_limit

    hud = Utils.get_hud()
    timer_on = true
    start_start()

func _on_WaveTimer_timeout():
    start_rest()


func _on_RestTimer_timeout():
    start_wave()

func start_wave():
    current_wave += 1
    hud.update_wave_info("Wave: " + str(current_wave))
    current_state = WAVE_STATE.WAVE
    emit_signal("wave_started", current_wave)
    wave_timer.start()

func start_rest():
    if current_wave >= last_wave:
        SceneManager.goto_scene("res://src/UI/GameWonControl.tscn")
    hud.update_wave_info("Rest")
    current_state = WAVE_STATE.REST
    emit_signal("rest_started")
    rest_timer.start()

func start_start():
    hud.update_wave_info("Start")
    current_state = WAVE_STATE.REST
    rest_timer.wait_time = 6
    rest_timer.start()

var time_remaining_secs = 0
func _process(delta):
    # TODO: Fix Slight offset
#    if(timer_on):
#        time += delta
#
#    # Total
#    var secs = fmod(time, 60)
#    var mins = fmod(time, 60*60) / 60
#    var time_passed_display = "%02d : %02d" % [mins,secs]

    # Remaining
    if current_state == WAVE_STATE.WAVE:
        time_remaining_secs = wave_timer.time_left
    else:
        time_remaining_secs = rest_timer.time_left

    var secs_remaining = clamp(fmod(time_remaining_secs, 60), 0, 60)
    var mins_remaining = fmod(time_remaining_secs, 60*60) / 60
    var time_remaining_display = "%02d : %02d" % [mins_remaining,secs_remaining]

    if hud:
        hud.update_wave_timer(time_remaining_display)
