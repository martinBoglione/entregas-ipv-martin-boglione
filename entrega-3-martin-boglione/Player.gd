extends CharacterBody2D
class_name Player
@onready var cannon:Sprite2D = $Cannon

@export var speed = 800
@export var acceleration := 30.0
@export var friction := 0.0
@export var gravity := 1000
@export var push_force := 600.0
var JUMP_FORCE := 700

var projectile_container:Node2D

func set_projectile_container(container:Node2D):
	cannon.projectile_container = container
	projectile_container = container

func get_input(delta):
	# Movimiento horizontal
	var input_direction = Input.get_axis("Left", "Right")

	if input_direction != 0:
		velocity.x += input_direction * acceleration
		velocity.x = clamp(velocity.x, -speed, speed)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = -JUMP_FORCE

	# Apuntar cañón
	var mouse_position: Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)

	# Disparar
	if Input.is_action_just_pressed("Fire"):
		cannon.fire()
		
func push_rigid_bodies():
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision == null:
			continue
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var normal := collision.get_normal()
			# Solo empujar horizontalmente
			var push_direction := Vector2(-normal.x, 0)
			if push_direction.x != 0:
				collider.apply_central_impulse(
					push_direction * push_force
				)
	
func _physics_process(delta):
	get_input(delta)
	move_and_slide()
	push_rigid_bodies()
