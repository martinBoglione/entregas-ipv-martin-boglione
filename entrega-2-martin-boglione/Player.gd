extends CharacterBody2D

@onready var cannon:Sprite2D = $Cannon

@export var speed = 400

var projectile_container:Node2D

func set_projectile_container(container:Node2D):
	cannon.projectile_container = container
	projectile_container = container

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Down", "Up")
	velocity = input_direction * speed
	
	var mouse_position:Vector2 = get_global_mouse_position()
	#var origen:Vector2 = global_position
	#var direction_vector:Vector2 = (mouse_position - origen)
	
	cannon.look_at(mouse_position)
	
	if Input.is_action_just_pressed("Fire"):
		cannon.fire()
	
func _physics_process(delta):
	get_input()
	move_and_slide()
