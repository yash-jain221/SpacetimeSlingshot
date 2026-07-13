extends MeshInstance3D
class_name GravityBody

const G:float = 1.0
enum BodyType {PLANET, ASTEROID, SHIP}

@export var mass: float = 100.0  
@export var initial_velocity: Vector3 = Vector3.ZERO
@export var radius: float = 1.0
@export var is_goal: bool = false  
@export var body_type:BodyType = BodyType.PLANET 

static var full_nbody: bool = false
var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = initial_velocity
	add_to_group("gravity_sources")

func _physics_process(delta: float) -> void:
	var acceleration = _gravity_at(global_position)
	velocity += acceleration * delta
	global_position += velocity * delta
	
func _gravity_at(point: Vector3)->Vector3:
	var accelaration := Vector3.ZERO
	for body in get_tree().get_nodes_in_group("gravity_sources"):
		if body == self:
			continue
		if not full_nbody and body.body_type == body_type:
			continue
		var offset = body.global_position - point
		var dist_sq: float = offset.length_squared()
		if dist_sq < 0.01:
			continue
		accelaration += offset.normalized() * (G * body.mass/dist_sq) 
	
	return accelaration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
