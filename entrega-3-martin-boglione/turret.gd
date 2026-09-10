extends Sprite2D

@export var projectile_scene:PackedScene
@onready var fire_position:Marker2D = $FirePosition
@onready var timer: Timer = $Timer

var projectile_container:Node2D
#var player
var target:Node2D

# Called when the node enters the scene tree for the first time.
func set_values(player, projectile_container):
	#self.player = player 
	self.projectile_container = projectile_container
	#$Timer.start()


func _on_timer_timeout() -> void:
	fire()
	
func fire():
	var projectile:Projectile = projectile_scene.instantiate()
	projectile_container.add_child(projectile)
	projectile.set_starting_values(fire_position.global_position,(target.global_position - fire_position.global_position).normalized())
	projectile.connect("delete_requested",_on_projectile_delete_requested)

func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player:
		target = body
		timer.start()
		fire()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		timer.stop()
