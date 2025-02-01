extends CharacterBody3D

#Physics variables
const SPEED = 7.0
const JUMP_VELOCITY = 5.5
const SENSITIVITY = 0.003;
var gravity = 16.8;

#Headbobbing freq
const HEADBOB_FREQ = 2.0;
const HEADBOB_AMP = 0.08;
var t_headbob = 0.0;

@onready var head = $Head;
@onready var camera = $Head/Camera3D;

#Hide and lock cursor to window
func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

#Calculate mouse movement according to sensitivity and lock Y axis to prevent spinning
func _unhandled_input (event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY);
		camera.rotate_x(-event.relative.y * SENSITIVITY);
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60));
		
func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta;

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 10.0);
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 10.0);
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7.0);
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7.0);
		
	t_headbob += delta * velocity.length() * float(is_on_floor());
	camera.transform.origin = _headbob(t_headbob);

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO;
	pos.y = sin(time * HEADBOB_FREQ) * HEADBOB_AMP;
	pos.x = cos(time * HEADBOB_FREQ / 2) * HEADBOB_AMP;
	return pos;
