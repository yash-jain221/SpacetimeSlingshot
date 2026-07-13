extends GravityBody
class_name Ship

enum State {AIMING, FLYING, LANDED}
var state: State = State.AIMING

@export var power_scale: float = 3.0
@export var aim_line:MeshInstance3D
@export var prediction_steps: int = 240

signal crashed(body)
signal reached_goal(body)

var _aiming: bool = false
var _launch_velocity: Vector3 = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if state == State.FLYING:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_aiming = event.pressed 
		if event.pressed: _update_aim(event.position)
		else: _launch()
	elif event is InputEventMouseMotion and _aiming:
		_update_aim(event.position)

func _predict_path(start_pos: Vector3, start_vel: Vector3) -> PackedVector3Array:
	var dt: float = 1.0/Engine.physics_ticks_per_second
	var points := PackedVector3Array()
	var pos := start_pos
	var vel := start_vel
	
	for step in prediction_steps:
		vel += _gravity_at(pos)*dt
		pos += vel*dt
		points.append(pos)
	
	return points

func _update_aim(screen_pos: Vector2):
	var target: Vector3 = _mouse_to_plane(screen_pos)
	_launch_velocity = (self.position - target)*power_scale
	_draw_path(_predict_path(global_position, _launch_velocity))

func _draw_path(points: PackedVector3Array)->void:
	var m := aim_line.mesh as ImmediateMesh
	m.clear_surfaces()
	if points.size()<2:
		return
	m.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	for p in points:
		m.surface_add_vertex(p)
	m.surface_end()
	
func _launch()->void:
	self.velocity = _launch_velocity
	state = State.FLYING
	_clear_aim_line()

func _mouse_to_plane(screen_pos: Vector2) -> Vector3:
	var cam := get_viewport().get_camera_3d()
	var from := cam.project_ray_origin(screen_pos)
	var dir := cam.project_ray_normal(screen_pos)
	var ground := Plane(Vector3.UP, 0.0)                    # the y = 0 play plane
	var hit = ground.intersects_ray(from, dir)
	return hit if hit != null else global_position
	
#func _draw_aim_line() -> void:
	#var m := aim_line.mesh as ImmediateMesh
	#m.clear_surfaces()
	#m.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	#m.surface_add_vertex(global_position)
	#m.surface_add_vertex(global_position + _launch_velocity)   # line length = power
	#m.surface_end()

func _clear_aim_line() -> void:
	(aim_line.mesh as ImmediateMesh).clear_surfaces()

		
func _physics_process(delta: float) -> void:
	if state == State.FLYING:
		super._physics_process(delta)
	_check_collisions()

func _check_collisions():
	for body in get_tree().get_nodes_in_group("gravity_sources"):
		if body ==self:
			continue
		if global_position.distance_to(body.global_position) <= body.radius:
			state = State.LANDED
			if body.is_goal:
				reached_goal.emit(body)
			else:
				crashed.emit(body)
			return
		

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
