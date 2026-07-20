extends Node


@export var angle_steps: int = 200
@export var power_steps: int = 100
@export var max_power: int = 45
@export var min_region_size: int = 5
@export var ship: Ship
@export var max_steps : int = 600
@export var save_path: String = "res://levels/level_01_solution.tres"

func _input(event: InputEvent)->void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		bake()
		
func bake() -> void:
	var start : Vector3 = ship.global_position
	var win := _sample_win_grid(start)
	var labels := _flood_fill(win) 
	var count := _filter_small(labels)
	print("basins after filter: ", count)
	_save(_flatten(labels), count)

func _sample_win_grid(start: Vector3) -> Array:
	var grid: Array = []
	for ai in angle_steps:
		var row: Array[int]
		for pi in power_steps:
			var angle := ai/float(angle_steps) * TAU
			var power := pi/float(power_steps) * max_power
			var vel := Vector2(cos(angle), sin(angle)) * power
			row.append(1 if _simulate(start, vel) else 0)   
		grid.append(row)
	return grid
	
func _simulate(pos: Vector3, vel: Vector2) -> bool:
	var dt := 1.0/Engine.physics_ticks_per_second
	for step in max_steps:
		vel+= ship._gravity_at(pos)*dt
		pos.x += vel.x*dt
		pos.z += vel.y*dt
		
		if pos.length() > ship.bounds_radius:
			return false
			
		for body in get_tree().get_nodes_in_group("gravity_sources"):
			if body == ship:
				continue
			if body.global_position.distance_to(pos) < body.radius:
				if body.is_goal:
					return true
				else:
					return false

	return false
		
## BFS over win launches (Number Of Islands problem)
func _flood_fill(win: Array) -> Array:
	var labels: Array = []
	for ai in angle_steps:
		var row: Array[int] = []
		for pi in power_steps:
			row.append(-1)
		labels.append(row)
	
	var next_id := 0
	for ai in angle_steps:
		for pi in power_steps:
			if win[ai][pi] == 1 and labels[ai][pi] == -1:
				_fill_component(win, labels, ai, pi, next_id)
				next_id+=1
				
	return labels

func _flatten(labels_2d: Array) -> PackedInt32Array:
	var flat := PackedInt32Array()
	for ai in angle_steps:
		for pi in power_steps:
			flat.append(labels_2d[ai][pi])
	return flat
	
func _fill_component(win: Array, labels: Array, start_ai: int, start_pi: int, id: int) -> void:
	var stack: Array = [Vector2i(start_ai, start_pi)]
	labels[start_ai][start_pi] = id
	while not stack.is_empty():
		var cell: Vector2i = stack.pop_back()
		for n in _neighbors(cell.x, cell.y):
			if win[n.x][n.y] == 1 and labels[n.x][n.y] == -1:
				labels[n.x][n.y] = id
				stack.append(n)

func _neighbors(ai: int, pi: int) -> Array:
	var result: Array = [
		Vector2i(wrapi(ai-1,0,angle_steps), pi),
		Vector2i(wrapi(ai+1, 0, angle_steps), pi),
	]
	if pi - 1>=0:
		result.append(Vector2i(ai, pi-1))
	if pi+1<power_steps:
		result.append(Vector2i(ai, pi+1))
	return result
	
func _filter_small(labels: Array)->int:
	var counts := {}
	for ai in angle_steps:
		for pi in power_steps:
			var id: int = labels[ai][pi]
			if id != -1:
				counts[id] = counts.get(id, 0) + 1

	var remap := {}
	var next_id := 0
	for id in counts:
		print("count of id %d: %d" % [id, counts[id]])
		if counts[id] >= min_region_size:
			remap[id] = next_id
			next_id += 1
		else:
			remap[id] = -1             
			
	for ai in angle_steps:
		for pi in power_steps:
			var id: int = labels[ai][pi]
			if id != -1:
				labels[ai][pi] = remap[id]

	return next_id

func _save(labels: PackedInt32Array, count: int) -> void:
	var sol := LevelSolution.new()
	sol.angle_steps = angle_steps
	sol.power_steps = power_steps
	sol.max_power = max_power
	sol.labels = labels
	sol.way_count = count

	var dir := save_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)   # create res://levels/ if missing

	var err := ResourceSaver.save(sol, save_path)
	print("save -> ", save_path, "  err=", err, "  (0 = OK)")
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
