class_name LevelSolution
extends Resource

@export var angle_steps: int = 200
@export var power_steps: int = 100
@export var max_power: int = 45
@export var way_count: int = 0
# flattened grid, index = angle_index * power_steps + power_index
# value = basin label (0..way_count-1), or -1 for a losing launch
@export var labels: PackedInt32Array

# Map a real launch to its basin (or -1 = not a counted route).
func label_for(angle: float, power: float) -> int:
	var ai = wrapi(int(angle / TAU * angle_steps), 0, angle_steps)
	var pi = clampi(int(power / max_power * power_steps), 0, power_steps - 1)
	return labels[ai * power_steps + pi]
