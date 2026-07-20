extends Node3D

@onready var ship:Ship = $Ship
@onready var nbody_toggle: CheckButton = $HUD/Chaos
@onready var banner: Label = $HUD/Banner
@onready var retry_button: Button = $HUD/RetryButton
@onready var replay_button: Button = $HUD/ReplayButton
@onready var next_level_button: Button = $HUD/NextLevelButton
@onready var counter: Label = $HUD/Counter
@export var solution: LevelSolution     # drag the baked .tres in
var _found := {}                        # set of basin labels discovered

signal ways_updated(found: int, total: int)
signal level_complete

	
# call from your reached_goal handler with the launch that won
func register_win(body, launch_vel: Vector2) -> void:
	var label := solution.label_for(atan2(launch_vel.y, launch_vel.x), launch_vel.length())
	print("win -> label ", label, "   found so far: ", _found.keys())
	if label == -1:
		return
	if not _found.has(label):
		_found[label] = true
		ways_updated.emit(_found.size(), solution.way_count)
				
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	counter.text = "0 / %d" % solution.way_count
	ship.crashed.connect(_on_crashed)
	ship.flew_away.connect(_on_flew_away)
	ship.reached_goal.connect(_on_reached_goal)
	level_complete.connect(_on_level_complete)
	ways_updated.connect(_on_ways_updated)
	nbody_toggle.toggled.connect(_on_nbody_toggled)
	GravityBody.full_nbody = nbody_toggle.button_pressed
	retry_button.pressed.connect(_on_retry_pressed)
	replay_button.pressed.connect(_on_retry_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)
	banner.hide()
	retry_button.hide()
	replay_button.hide()
	next_level_button.hide()
	
func _on_nbody_toggled(toggled_on: bool) -> void:
	GravityBody.full_nbody = toggled_on
	
func _on_crashed(body):
	_end_round("Crashed into "+body.name)
	retry_button.show()

func _on_flew_away():
	_end_round("Into The Void!")
	retry_button.show()
	
func _on_reached_goal(body, launch_vel):
	register_win(body, launch_vel)
	if _found.size() == solution.way_count:
		_end_round("Level complete!")
		replay_button.show()
		next_level_button.show()
	else:
		ship.reset_for_next_attempt()

func _on_level_complete():
	_end_round("LEVEL PASSED!")
	

func _on_ways_updated(found, total):
	counter.text = "%d / %d" % [found, total]
	
func _end_round(message: String) -> void:
	banner.text = message
	banner.show()
	
func _on_retry_pressed():
	get_tree().reload_current_scene()

func _on_next_level_pressed():
	get_tree().reload_current_scene()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
