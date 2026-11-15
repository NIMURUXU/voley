extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocidad_antes_de_chocar: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("u1") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("l1", "r1")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	velocidad_antes_de_chocar = velocity

	move_and_slide()
