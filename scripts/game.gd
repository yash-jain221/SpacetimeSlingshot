extends Node3D

@onready var ship:Ship = $Ship
@onready var nbody_toggle: CheckButton = $HUD/Chaos



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.crashed.connect(_on_crashed)
	ship.reached_goal.connect(_on_reached_goal)
	nbody_toggle.toggled.connect(_on_nbody_toggled)
	GravityBody.full_nbody = nbody_toggle.button_pressed

func _on_nbody_toggled(toggled_on: bool) -> void:
	GravityBody.full_nbody = toggled_on
	
func _on_crashed(body):
	print("CRASHED")
	
func _on_reached_goal(body):
	print("REACHED GOAL")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
