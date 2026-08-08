class_name PathFollow extends PathFollow2D

@export var speed: float = 0.1

@onready var enemy: Enemy = $Enemy

var dead: bool = false

func _process(delta: float) -> void:
	if dead == false:
		progress_ratio += speed * delta

func _ready() -> void:
	enemy.dead.connect(on_death)

func on_death() -> void:
	dead = true
