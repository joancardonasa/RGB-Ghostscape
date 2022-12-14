# Author Kamyab Nazari - 2021

extends KinematicBody

# Playercontroller for movement

onready var _transition = $SceneTransition;

onready var main_cam = $Head/LeanGimbal/Camera
onready var gun_cam = $ViewportContainer/Viewport/Camera

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
const LEAN_AMOUNT : float = 0.7

# Mouse sensitivity
var mouse_sense = 0.1
var snap

var currentStrafeDir = 0

# Vectors for movement
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var boost_vec = Vector3()

# Onready variables
onready var accel = ACCEL_TYPE["default"]
onready var head = $Head
onready var stats = $Stats
onready var camera = $Head/LeanGimbal/Camera
onready var lean_gimbal = $Head/LeanGimbal
onready var _footstep_sfx = $FootstepSFX

# Variables for boosts
var _speed_mult: float = 1.0
var _invulnerable: bool = false
var _footstep_acc: float = 0.0

func _ready():
    # Hides the cursor
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    # warning-ignore:return_value_discarded
    var card_manager = Utils.get_card_manager()
    card_manager.connect("Player_SpeedMult", self, "_on_Card_SpeedMult")
    card_manager.connect("Player_Heal", self, "_on_Card_Heal")
    card_manager.connect("Player_Invulnerable", self, "_on_Card_Invulnerable")

func _input(event):
    # Get mouse input for camera rotation
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(deg2rad(-event.relative.x * mouse_sense))
        head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
        head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
    if event.is_action_pressed("restart_dev"):
        SceneManager.goto_scene("res://src/maps/Map.tscn")
        

func _process(delta):
    lean_gimbal.rotation.z = lerp(lean_gimbal.rotation.z, currentStrafeDir * LEAN_MULT, delta * LEAN_SMOOTH)
    gun_cam.global_transform = main_cam.global_transform

func _physics_process(delta):
    # Get keyboard input
    direction = Vector3.ZERO
    var h_rot = global_transform.basis.get_euler().y
    var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
    var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

    # Check if to lean
    if(h_input < 0):
        currentStrafeDir = LEAN_AMOUNT
    elif(h_input > 0):
        currentStrafeDir = -LEAN_AMOUNT
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
    
    if boost_vec != Vector3.ZERO:
        snap = Vector3.ZERO
        if (boost_vec.y > 0):
            gravity_vec = Vector3.UP * boost_vec.y
        velocity += Vector3(boost_vec.x, 0, boost_vec.z)
        boost_vec = Vector3.ZERO
    
    # Moving
    velocity = velocity.linear_interpolate(direction * (SPEED * _speed_mult), accel * delta)
    if(gravity_vec > Vector3.ZERO):
        movement = velocity + gravity_vec * JUMP_MULTY
    elif(gravity_vec < Vector3.ZERO):
        movement = velocity + gravity_vec * FALL_MULTY
    else:
        movement = velocity + gravity_vec

    if is_on_floor():
        _footstep_acc += movement.length()
        if _footstep_acc > 200:
            Sound.play(_footstep_sfx)
            _footstep_acc = 0
    else:
        # Always make sound when landing
        _footstep_acc = 1000
    
    move_and_slide_with_snap(movement, snap, Vector3.UP)

func _on_Stats_died_signal():
    Sound.get_node("DeathSound").play()
    var a_player = _transition.fade_in() # animation_player
    yield(a_player, "animation_finished")
    queue_free()
    SceneManager.goto_scene("res://src/UI/GameOverControl.tscn")

func _on_Card_SpeedMult(enable : bool, mult : float):
    _speed_mult = mult if enable else 1.0

func _on_Card_Heal(amount : int):
    stats.heal(amount)

func _on_HurtBox_damage_taken():
    if not Globals.GODMODE and not _invulnerable:
        $HUD.flash_hurt_vignette()
        Sound.get_node("HitSound").play()
        stats.take_hit(1)

func boost(force: Vector3):
    boost_vec = force

func _on_Card_Invulnerable(enable : bool):
    _invulnerable = enable
