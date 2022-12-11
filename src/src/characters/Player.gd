# Author Kamyab Nazari - 2021

extends KinematicBody

# Playercontroller for movement

onready var spell_controller = $SpellController
onready var _transition = $SceneTransition;

# Constant variables for Movement
const SPEED = 10
const GRAVITY = 10
const JUMP = 8
const FALL_MULTY = 2
const JUMP_MULTY = 0.9
const CAM_ACCEL = 40
const ACCEL_TYPE = {"default": 10, "air": 1}

# Strafe leaning
const LEAN_SMOOTH : float = 10.0
const LEAN_MULT : float = 0.066
const LEAM_AMOUNT : float = 0.7

# Mouse sensitivity
var mouse_sense = 0.1
var snap

var currentStrafeDir = 0

# Vectors for movement
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

# Onready variables
onready var accel = ACCEL_TYPE["default"]
onready var head = $Head
onready var camera = $Head/Camera

# Variables for boosts
var _speed_mult: float = 1.0

# Player Actions
var _shooting_allowed: bool = false

func _ready():
    # Hides the cursor
    Sound.get_node("RestartSound").play()
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    # warning-ignore:return_value_discarded
    var card_manager = Utils.get_card_manager()
    card_manager.connect("Player_SpeedMult", self, "_on_Card_SpeedMult")

func _input(event):
    # Get mouse input for camera rotation
    if event is InputEventMouseMotion:
        rotate_y(deg2rad(-event.relative.x * mouse_sense))
        head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
        head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
    if event.is_action_pressed("restart_dev"):
        SceneManager.goto_scene("res://src/maps/Map.tscn")

func _process(delta):
    camera.set_as_toplevel(false)
    camera.global_transform = head.global_transform

    head.rotation.z = lerp(head.rotation.z, currentStrafeDir * LEAN_MULT, delta * LEAN_SMOOTH)

func _physics_process(delta):
    # Get keyboard input
    direction = Vector3.ZERO
    var h_rot = global_transform.basis.get_euler().y
    var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
    var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

    # Check if to lean
    if(h_input < 0):
        currentStrafeDir = LEAM_AMOUNT
    elif(h_input > 0):
        currentStrafeDir = -LEAM_AMOUNT
    else:
        currentStrafeDir = 0
    
    direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
    
    # Jumping and gravity
    if is_on_floor():
        snap = -get_floor_normal()
        accel = ACCEL_TYPE["default"]
        gravity_vec = Vector3.ZERO
    else:
        snap = Vector3.DOWN
        accel = ACCEL_TYPE["air"]
        gravity_vec += Vector3.DOWN * GRAVITY * delta
        
    if Input.is_action_just_pressed("jump") and is_on_floor():
        snap = Vector3.ZERO
        gravity_vec = Vector3.UP * JUMP
    
    # Moving
    velocity = velocity.linear_interpolate(direction * (SPEED * _speed_mult), accel * delta)
    if(gravity_vec > Vector3.ZERO):
        movement = velocity + gravity_vec * JUMP_MULTY
    elif(gravity_vec < Vector3.ZERO):
        movement = velocity + gravity_vec * FALL_MULTY
    else:
        movement = velocity + gravity_vec

    # warning-ignore:return_value_discarded
    move_and_slide_with_snap(movement, snap, Vector3.UP)
    
    # Casting
#    if Input.is_action_pressed("primary_action") and _shooting_allowed:
#        $Head/WeaponManager.
        #spell_controller.cast()

func _on_Stats_died_signal():
    Sound.get_node("DeathSound").play()
    var a_player = _transition.fade_in() # animation_player
    yield(a_player, "animation_finished")
    queue_free()
    SceneManager.goto_scene("res://src/maps/Map.tscn")

func _on_Card_SpeedMult(enable : bool, mult : float):
    _speed_mult = mult if enable else 1.0

