extends GravityBody
class_name Ship

enum State {AIMING, FLYING, LANDED}
var state: State = State.AIMING

@export var power_scale: float = 3.0
@export var aim_line:MeshInstance3D
@export var prediction_steps: int = 400
@export var bounds_radius: float = 40.0
@export var max_drag: int = 15 


signal crashed(body)
signal reached_goal(body)
signal flew_away(body)

var _aiming: bool = false
var _launch_velocity: Vector2 = Vector2.ZERO
var _start_position: Vector3

func reset_for_next_attempt() -> void:
	global_position = _start_position
	velocity = Vector2.ZERO      # your velocity is Vector2
	state = State.AIMING
	_clear_aim_line()
		
func _unhandled_input(event: InputEvent) -> void:
	if state == State.FLYING:
		return
	if state != State.AIMING:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_aiming = event.pressed 
		if event.pressed: _update_aim(event.position)
		else: _launch()
	elif event is InputEventMouseMotion and _aiming:
		_update_aim(event.position)


func _predict_path(start_pos: Vector3, start_vel: Vector2) -> PackedVector3Array:
	var dt: float = 1.0/Engine.physics_ticks_per_second
	var points := PackedVector3Array()
	var pos := start_pos
	var vel := start_vel
	
	for step in prediction_steps:
		vel += _gravity_at(pos)*dt
		pos.x += vel.x*dt
		pos.z += vel.y*dt
		points.append(pos)
	
	return points

func _update_aim(screen_pos: Vector2):
	var target: Vector3 = _mouse_to_plane(screen_pos)
	var drag := Vector2(global_position.x - target.x, global_position.z - target.z)
	drag = drag.limit_length(max_drag)              # cap it — this is the whole fix
	_launch_velocity = drag * power_scale
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
	var ground := Plane(Vector3.UP, 0.0)                    
	var hit = ground.intersects_ray(from, dir)
	return hit if hit != null else global_position

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
		if global_position.length() > bounds_radius:
			state = State.LANDED
			flew_away.emit()
			return
			
		if global_position.distance_to(body.global_position) <= body.radius:
			state = State.LANDED
			if body.is_goal:
				reached_goal.emit(body,  _launch_velocity)
			else:
				crashed.emit(body)
			return
		

func _ready() -> void:
	_start_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
