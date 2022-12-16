extends Node

onready var wave_timer = $WaveTimer
onready var rest_timer = $RestTimer

# Seconds
export(float) var wave_time_limit = 60
export(float) var rest_time_limit = 10

var current_wave: int = 0
var last_wave: int = 4

var time: float = 0
var timer_on = false

enum WAVE_STATE {
    WAVE,
    REST
}

var current_state

var hud = null

func _ready():
    timer_on = true
    wave_timer.wait_time = wave_time_limit
    rest_timer.wait_time = rest_time_limit
    start_rest()

    hud = Utils.get_hud()

func _on_WaveTimer_timeout():
    rest_timer.start()


func _on_RestTimer_timeout():
    wave_timer.start()

func start_wave():
    current_state = WAVE_STATE.WAVE
    wave_timer.start()

func start_rest():
    current_state = WAVE_STATE.REST
    rest_timer.start()


func _process(delta):
    if(timer_on):
        time += delta

    var time_limit_secs: float = rest_time_limit
    var time_remaining_secs = time_limit_secs - time

    var secs_remaining = clamp(fmod(time_remaining_secs, 60), 0, 60)
    var mins_remaining = fmod(time_remaining_secs, 60*60) / 60

    var time_remaining_display = "       %02d : %02d" % [mins_remaining,secs_remaining]

#    var secs = fmod(time, 60)
#    var mins = fmod(time, 60*60) / 60
#    var hr = fmod(fmod(time, 3600 * 60) / 3600,24)
#
#    if hr >= 1 and not hour_has_passed:
#        hour_has_passed = true
#        SteamManager.set_achievement("PATIENT_SURVIVAL")
#
#    var time_passed = "%02d : %02d : %02d" % [hr,mins,secs]
#
#    notify_game_minute_passed(mins)
#
#    if not is_time_limit:
#        if run_timer_label:
#            run_timer_label.text = time_passed
#    else:
#        var time_limit_secs: float = time_limit_minutes * 60
#
#        var time_remaining_secs = time_limit_secs - time
#
#        var secs_remaining = clamp(fmod(time_remaining_secs, 60), 0, 60)
#        var mins_remaining = fmod(time_remaining_secs, 60*60) / 60
#        #var hr_remaining = fmod(fmod(time_remaining_msecs, 3600 * 60) / 3600,24)
#
#        var time_remaining_display = "       %02d : %02d" % [mins_remaining,secs_remaining]
#
#        if run_timer_label:
#            run_timer_label.text = time_remaining_display
#
#        # Grace period
#        if timer_on and player and time_remaining_secs <= -3:
#            timer_on = false
#            player.health_manager.die()
