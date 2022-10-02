extends KinematicBody


export var maxSpeed = 12
export var acceleration = 60
export var friction = 50
export var airFriction = 10
export var jumpImpulse = 20
export var gravity = -40

export var mouseSensitivity = .1
export var controllerSensitivity = 3

export (int, 0, 10) var push = 10

var Velocity = Vector3.ZERO
var snapVector = Vector3.ZERO

onready var head = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event.is_action_pressed("toggleMouseMode"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity))	
		head.rotate_x(deg2rad(-event.relative.y * mouseSensitivity))
			
func _physics_process(delta):
	var inputVector = getInputVector()
	var direction = getDirection(inputVector)
	applyMovement(direction, delta)
	applyControllerRotation()
	applyFriction(direction, delta)
	applyGravity(delta)
	jump()
	head.rotation.x = clamp(head.rotation.x, deg2rad(-75), deg2rad(75))
	Velocity = move_and_slide_with_snap(Velocity, snapVector, Vector3.UP, true, 4, .785398, false)
	
	for idx in get_slide_count():
		var collision = get_slide_collision(idx)
		if collision.collider.is_in_group("interactions"):
			collision.collider.apply_central_impulse(-collision.normal * Velocity.length() * push)
			
			
	
	
func getInputVector():
	var inputVector = Vector3.ZERO
	
	inputVector.x = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
	inputVector.z = Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp")
	return inputVector.normalized() if inputVector.length() > 1 else inputVector

func getDirection(inputVector):
	var direction = Vector3.ZERO
	direction = (inputVector.x * transform.basis.x) + (inputVector.z * transform.basis.z)
	return direction
	
func applyMovement(direction, delta):
	if direction != Vector3.ZERO:
		Velocity.x = Velocity.move_toward(direction * maxSpeed, acceleration * delta).x
		Velocity.z = Velocity.move_toward(direction * maxSpeed, acceleration * delta).z
	
	
func applyFriction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			Velocity = Velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			Velocity.x = Velocity.move_toward(Vector3.ZERO, airFriction * delta).x
			Velocity.z = Velocity.move_toward(Vector3.ZERO, airFriction * delta).z
			
func applyGravity(delta):
	Velocity.y += gravity * delta
	Velocity.y = clamp(Velocity.y, gravity, jumpImpulse)

func updateSnapVector():
	snapVector = -get_floor_normal() if is_on_floor() else Vector3.DOWN


func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snapVector = Vector3.ZERO
		Velocity.y = jumpImpulse
	if Input.is_action_just_released("jump") and Velocity.y > jumpImpulse:
		Velocity.y = jumpImpulse / 2
		
func applyControllerRotation():
	var axisVector = Vector2.ZERO
	axisVector.x = Input.get_action_strength("lookRight") - Input.get_action_strength("lookLeft")
	axisVector.y = Input.get_action_strength("lookDown") - Input.get_action_strength("lookUp")
	
	if InputEventJoypadMotion:
		rotate_y(deg2rad(-axisVector.x) * controllerSensitivity)
		head.rotate_x(deg2rad(-axisVector.y) * controllerSensitivity)
