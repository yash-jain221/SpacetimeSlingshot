extends Node3D

@onready var ship:Ship = $Ship
@onready var nbody_toggle: CheckButton = $HUD/Chaos
@onready var banner: Label = $HUD/Banner
@onready var retry_button: Button = $HUD/RetryButton





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.crashed.connect(_on_crashed)
	ship.reached_goal.connect(_on_reached_goal)
	nbody_toggle.toggled.connect(_on_nbody_toggled)
	GravityBody.full_nbody = nbody_toggle.button_pressed
	retry_button.pressed.connect(_on_retry_pressed)
	banner.hide()
	retry_button.hide()
	
	

func _on_nbody_toggled(toggled_on: bool) -> void:
	GravityBody.full_nbody = toggled_on
	
func _on_crashed(body):
	_end_round("Crashed into "+body.name)
	
func _on_reached_goal(body):
	_end_round("Reached " + body.name + "!")
	
func _end_round(message: String) -> void:
	banner.text = message
	banner.show()
	retry_button.show()
	
func _on_retry_pressed():
	get_tree().reload_current_scene()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
