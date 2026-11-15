extends RigidBody2D

@export var fuerza_base: float = 480.0
@export var multiplicador_velocidad_jugador: float = 0.9
@export var conservacion_velocidad_balon: float = 0.45
@export var velocidad_maxima: float = 1100.0

func _ready():
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	if linear_velocity.length() > velocidad_maxima:
		linear_velocity = linear_velocity.normalized() * velocidad_maxima

func _on_body_entered(body: Node):
	if body is CharacterBody2D:
		impulsar_balon(body)

func impulsar_balon(jugador: CharacterBody2D):
	var direccion = (global_position - jugador.global_position).normalized()
	direccion.y = min(direccion.y, -0.5)
	direccion = direccion.normalized()
	
	var vel_jugador = Vector2.ZERO
	if "velocidad_antes_de_chocar" in jugador:
		vel_jugador = jugador.velocidad_antes_de_chocar
	else:
		vel_jugador = jugador.velocity
	
	var rapidez_jugador = vel_jugador.length() * multiplicador_velocidad_jugador
	var rapidez_balon = linear_velocity.length() * conservacion_velocidad_balon
	var rapidez_total = fuerza_base + rapidez_jugador + rapidez_balon
	
	var nueva_velocidad = direccion * rapidez_total
	nueva_velocidad.x += vel_jugador.x * 0.3
	
	if nueva_velocidad.y > -480.0:
		nueva_velocidad.y = -480.0
		
	linear_velocity = nueva_velocidad

# Agrega esta función al final del script de tu balón
func reiniciar_saque(posicion_saque: Vector2):
	# En Godot 4, para teletransportar un RigidBody2D de forma segura se usa PhysicsServer2D o call_deferred
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	global_position = posicion_saque
