extends MeshInstance3D


@export var mass: float = 100.0
func _ready() -> void:
	add_to_group("gravity_sources")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
